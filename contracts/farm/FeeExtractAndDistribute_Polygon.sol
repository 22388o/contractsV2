/**
 * Copyright 2017-2022, OokiDao. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0.
 */

pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin-4.3.2/token/ERC20/IERC20.sol";
import "./interfaces/IUniswapV2Router.sol";
import "../../interfaces/IBZx.sol";
import "@celer/contracts/interfaces/IBridge.sol";
import "../../interfaces/IPriceFeeds.sol";
import "../governance/PausableGuardian_0_8.sol";

contract FeeExtractAndDistribute_Polygon is PausableGuardian_0_8 {
    address public implementation;
    IBZx public constant BZX = IBZx(0x059D60a9CEfBc70b9Ea9FFBb9a041581B1dFA6a8);

    address public constant BUYBACK_ADDRESS =
        0x12EBd8263A54751Aaf9d8C2c74740A8e62C0AfBe;
    address public constant MATIC = 0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270;
    address public constant USDC = 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174;
    uint256 public constant WEI_PRECISION_PERCENT = 10**20;
    uint64 public constant DEST_CHAINID = 1; //to be set
    uint256 public constant MIN_USDC_AMOUNT = 20e6; //1000 USDC minimum bridge amount
    IUniswapV2Router public constant SWAPS_ROUTER_V2 =
        IUniswapV2Router(0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506); // Sushiswap

    address internal constant ZERO_ADDRESS = address(0);

    mapping(address => uint256) public exportedFees;

    address[] public currentFeeTokens;

    address payable public treasuryWallet;

    address public bridge; //bridging contract

    uint256 public buybackPercentInWEI; //set to 30e18

    event ExtractAndDistribute(uint256 amountTreasury, uint256 amountStakers);

    event AssetSwap(
        address indexed sender,
        address indexed srcAsset,
        address indexed dstAsset,
        uint256 srcAmount,
        uint256 dstAmount
    );

    function sweepFees() public pausable {
        _extractAndDistribute(currentFeeTokens);
    }

    function sweepFees(address[] memory assets) public pausable {
        _extractAndDistribute(assets);
    }

    function _extractAndDistribute(address[] memory assets) internal {
        uint256[] memory amounts = BZX.withdrawFees(
            assets,
            address(this),
            IBZx.FeeClaimType.All
        );

        for (uint256 i = 0; i < assets.length; i++) {
            exportedFees[assets[i]] += amounts[i];
        }

        uint256 usdcOutput = exportedFees[USDC];
        exportedFees[USDC] = 0;

        address asset;
        uint256 amount;
        for (uint256 i = 0; i < assets.length; i++) {
            asset = assets[i];
            if (asset == USDC) continue; //USDC already accounted for
            amount = exportedFees[asset];
            exportedFees[asset] = 0;

            if (amount != 0) {
                usdcOutput += asset == MATIC
                    ? _swapWithPair([asset, USDC], amount)
                    : _swapWithPair([asset, MATIC, USDC], amount); //builds route for all tokens to route through MATIC
            }
        }
        if (usdcOutput != 0) {
            _bridgeFeesAndDistribute(); //bridges fees to Ethereum to be distributed to stakers
            emit ExtractAndDistribute(usdcOutput, 0); //for tracking distribution amounts
        }
    }

    function _swapWithPair(address[2] memory route, uint256 inAmount)
        internal
        returns (uint256 returnAmount)
    {
        address[] memory path = new address[](2);
        path[0] = route[0];
        path[1] = route[1];
        uint256[] memory amounts = SWAPS_ROUTER_V2.swapExactTokensForTokens(
            inAmount,
            1, // amountOutMin
            path,
            address(this),
            block.timestamp
        );

        returnAmount = amounts[1];
        _checkUniDisagreement(path[0], inAmount, returnAmount, 5e18);
    }

    function _swapWithPair(address[3] memory route, uint256 inAmount)
        internal
        returns (uint256 returnAmount)
    {
        address[] memory path = new address[](3);
        path[0] = route[0];
        path[1] = route[1];
        path[2] = route[2];
        uint256[] memory amounts = SWAPS_ROUTER_V2.swapExactTokensForTokens(
            inAmount,
            1, // amountOutMin
            path,
            address(this),
            block.timestamp
        );

        returnAmount = amounts[2];
        _checkUniDisagreement(path[0], inAmount, returnAmount, 5e18);
    }

    function _bridgeFeesAndDistribute() internal {
        uint256 total = IERC20(USDC).balanceOf(address(this));
        IERC20(USDC).transfer(
            BUYBACK_ADDRESS,
            (total * buybackPercentInWEI) / WEI_PRECISION_PERCENT
        ); //allocates funds for buyback
        require(
            IERC20(USDC).balanceOf(address(this)) > MIN_USDC_AMOUNT,
            "FeeExtractAndDistribute: bridge amount too low"
        );
        IBridge(bridge).send(
            treasuryWallet,
            USDC,
            IERC20(USDC).balanceOf(address(this)),
            DEST_CHAINID,
            uint64(block.timestamp),
            10000
        );
    }

    function _checkUniDisagreement(
        address asset,
        uint256 assetAmount,
        uint256 recvAmount,
        uint256 maxDisagreement
    ) internal view {
        uint256 estAmountOut = IPriceFeeds(BZX.priceFeeds()).queryReturn(
            asset,
            USDC,
            assetAmount
        );

        uint256 spreadValue = estAmountOut > recvAmount
            ? estAmountOut - recvAmount
            : recvAmount - estAmountOut;
        if (spreadValue != 0) {
            spreadValue = (spreadValue * 1e20) / estAmountOut;

            require(
                spreadValue <= maxDisagreement,
                "uniswap price disagreement"
            );
        }
    }

    // OnlyOwner functions

    function setTreasuryWallet(address payable _wallet) external onlyOwner {
        treasuryWallet = _wallet;
    }

    function setFeeTokens(address[] calldata tokens) external onlyOwner {
        currentFeeTokens = tokens;
        for (uint256 i = 0; i < tokens.length; i++) {
            IERC20(tokens[i]).approve(address(SWAPS_ROUTER_V2), 0);
            IERC20(tokens[i]).approve(
                address(SWAPS_ROUTER_V2),
                type(uint256).max
            );
        }
    }

    function setBridgeApproval(address token) external onlyOwner {
        IERC20(token).approve(bridge, 0);
        IERC20(token).approve(bridge, type(uint256).max);
    }

    function setBridge(address _wallet) external onlyOwner {
        bridge = _wallet;
    }

    function setBuyBackPercentage(uint256 _percentage) external onlyOwner {
        buybackPercentInWEI = _percentage;
    }
}
