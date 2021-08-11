/**
 * Copyright 2017-2020, bZeroX, LLC <https://bzx.network/>. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0.
 */

pragma solidity 0.5.17;
pragma experimental ABIEncoderV2;

import "./StakingState.sol";
import "./StakingConstants.sol";
import "../interfaces/IVestingToken.sol";
import "../../interfaces/IBZx.sol";
import "../../interfaces/IPriceFeeds.sol";
import "../utils/MathUtil.sol";
import "../farm/interfaces/IMasterChefSushi.sol";
import "./interfaces/IStakingPartial.sol";


contract StakingV1_1 is StakingState, StakingConstants {
    using MathUtil for uint256;

    modifier onlyEOA() {
        require(msg.sender == tx.origin, "unauthorized");
        _;
    }

    modifier checkPause() {
        require(!isPaused, "paused");
        _;
    }

    function setStakingRewards(address asset, uint256 value)
        external
        onlyOwner
    {
        stakingRewards[asset] = value;
    }

    // View function to see pending sushi rewards on frontend.
    function pendingSushiRewards(address _user)
        external
        view
        returns (uint256)
    {
        uint256 userSupply = balanceOfByAsset(LPToken, _user);
        return _pendingAltRewards(SUSHI, _user, userSupply);
    }

    function _pendingAltRewards(address token, address _user, uint256 userSupply)
        internal
        view
        returns (uint256)
    {
        uint256[] memory _altRewardsRounds = altRewardsRounds[token];
        uint256 _currentRound = _altRewardsRounds.length;
        if (_currentRound == 0)
            return 0;

        if (userSupply == 0)
            return 0;

        uint256 _lastClaimedRound = userAltRewardsRounds[_user];
        uint256 currentAccumulatedAltRewards = _altRewardsRounds[_currentRound-1];

        //Never claimed yet
        if (_lastClaimedRound == 0) {
            return userSupply
            .mul(currentAccumulatedAltRewards)
            .div(1e12);
        }
        _lastClaimedRound -= 1; //correct index to start from 0
        _currentRound -= 1; //correct index to start from 0

        //Already claimed everything
        if (_lastClaimedRound == _currentRound) {
            return 0;
        }

        uint256 _lastAccumulatedAltRewards = _altRewardsRounds[_lastClaimedRound];
        uint256 _currentRewards = userSupply.mul(currentAccumulatedAltRewards);
        uint256 _clamedRewards = userSupply.mul(_lastAccumulatedAltRewards);
        return (_currentRewards.sub(_clamedRewards)).div(1e12);
    }

    function _paySushiRewards(address _user, uint256 pendingSushi) internal {

        //Update userAltRewardsRounds even if user got nothing in the current round
        uint256[] memory _altRewardsPerShare = altRewardsRounds[SUSHI];
        if (_altRewardsPerShare.length > 0) {
            userAltRewardsRounds[_user] = _altRewardsPerShare.length;
        }

        if (pendingSushi != 0) {
            IERC20(SUSHI).safeTransfer(_user, pendingSushi);
            emit ClaimAltRewards(_user, SUSHI, pendingSushi);
        }

    }

    function stake(
        address[] calldata tokens,
        uint256[] calldata values)
        external
        checkPause
        updateRewards(msg.sender)
    {
        require(tokens.length == values.length, "count mismatch");

        /*address currentDelegate = delegate[msg.sender];
        if (currentDelegate == address(0)) {
            currentDelegate = msg.sender;
            delegate[msg.sender] = currentDelegate;
            _delegatedSet.addAddress(msg.sender);
        }*/

        address token;
        uint256 stakeAmount;
        uint256 lptUserSupply = balanceOfByAsset(LPToken, msg.sender);

        for (uint256 i = 0; i < tokens.length; i++) {
            token = tokens[i];
            require(token == BZRX || token == vBZRX || token == iBZRX || token == LPToken, "invalid token");

            stakeAmount = values[i];
            if (stakeAmount == 0) {
                continue;
            }

            _balancesPerToken[token][msg.sender] = _balancesPerToken[token][msg.sender].add(stakeAmount);
            _totalSupplyPerToken[token] = _totalSupplyPerToken[token].add(stakeAmount);

            /*delegatedPerToken[currentDelegate][token] = delegatedPerToken[currentDelegate][token]
                .add(stakeAmount);*/

            IERC20(token).safeTransferFrom(msg.sender, address(this), stakeAmount);

            //Deposit to sushi masterchef
            if(token == LPToken){
                uint256 sushiBalanceBefore = IERC20(SUSHI).balanceOf(address(this));
                IMasterChefSushi(SUSHI_MASTERCHEF).deposit(BZRX_ETH_SUSHI_MASTERCHEF_PID, stakeAmount);
                uint256 sushiRewards = IERC20(SUSHI).balanceOf(address(this)) - sushiBalanceBefore;
                if(sushiRewards != 0){
                    _addAltRewards(SUSHI, sushiRewards);
                }
            }
            emit Stake(
                msg.sender,
                token,
                msg.sender, //currentDelegate,
                stakeAmount
            );
        }

        _paySushiRewards(
            msg.sender,
            _pendingAltRewards(SUSHI, msg.sender, lptUserSupply)
        );

    }

    function unstake(
        address[] memory tokens,
        uint256[] memory values)
        public
        checkPause
        updateRewards(msg.sender)
    {
        require(tokens.length == values.length, "count mismatch");

        //address currentDelegate = delegate[msg.sender];

        address token;
        uint256 unstakeAmount;
        uint256 stakedAmount;
        uint256 lptUserSupply = balanceOfByAsset(LPToken, msg.sender);

        for (uint256 i = 0; i < tokens.length; i++) {
            token = tokens[i];
            require(token == BZRX || token == vBZRX || token == iBZRX || token == LPToken || token == LPTokenOld, "invalid token");

            unstakeAmount = values[i];
            stakedAmount = _balancesPerToken[token][msg.sender];
            if (unstakeAmount == 0 || stakedAmount == 0) {
                continue;
            }
            if (unstakeAmount > stakedAmount) {
                unstakeAmount = stakedAmount;
            }

            _balancesPerToken[token][msg.sender] = stakedAmount - unstakeAmount; // will not overflow
            _totalSupplyPerToken[token] = _totalSupplyPerToken[token] - unstakeAmount; // will not overflow

            /*delegatedPerToken[currentDelegate][token] = delegatedPerToken[currentDelegate][token]
                .sub(unstakeAmount);*/

            if (token == BZRX && IERC20(BZRX).balanceOf(address(this)) < unstakeAmount) {
                // settle vested BZRX only if needed
                IVestingToken(vBZRX).claim();
            }

            //Withdraw to sushi masterchef
            if(token == LPToken){
                uint256 sushiBalanceBefore = IERC20(SUSHI).balanceOf(address(this));
                IMasterChefSushi(SUSHI_MASTERCHEF).withdraw(BZRX_ETH_SUSHI_MASTERCHEF_PID, unstakeAmount);
                uint256 sushiRewards = IERC20(SUSHI).balanceOf(address(this)) - sushiBalanceBefore;
                if(sushiRewards != 0){
                    _addAltRewards(SUSHI, sushiRewards);
                }
            }

            IERC20(token).safeTransfer(msg.sender, unstakeAmount);

            emit Unstake(
                msg.sender,
                token,
                msg.sender, //currentDelegate,
                unstakeAmount
            );
        }

        _paySushiRewards(
            msg.sender,
            _pendingAltRewards(SUSHI, msg.sender, lptUserSupply)
        );
    }

    /*function changeDelegate(
        address delegateToSet)
        external
        checkPause
    {
        if (delegateToSet == ZERO_ADDRESS) {
            delegateToSet = msg.sender;
        }

        address currentDelegate = delegate[msg.sender];
        if (delegateToSet != currentDelegate) {
            if (currentDelegate != ZERO_ADDRESS) {
                uint256 balance = _balancesPerToken[BZRX][msg.sender];
                if (balance != 0) {
                    delegatedPerToken[currentDelegate][BZRX] = delegatedPerToken[currentDelegate][BZRX]
                        .sub(balance);
                    delegatedPerToken[delegateToSet][BZRX] = delegatedPerToken[delegateToSet][BZRX]
                        .add(balance);
                }

                balance = _balancesPerToken[vBZRX][msg.sender];
                if (balance != 0) {
                    delegatedPerToken[currentDelegate][vBZRX] = delegatedPerToken[currentDelegate][vBZRX]
                        .sub(balance);
                    delegatedPerToken[delegateToSet][vBZRX] = delegatedPerToken[delegateToSet][vBZRX]
                        .add(balance);
                }

                balance = _balancesPerToken[iBZRX][msg.sender];
                if (balance != 0) {
                    delegatedPerToken[currentDelegate][iBZRX] = delegatedPerToken[currentDelegate][iBZRX]
                        .sub(balance);
                    delegatedPerToken[delegateToSet][iBZRX] = delegatedPerToken[delegateToSet][iBZRX]
                        .add(balance);
                }

                balance = _balancesPerToken[LPToken][msg.sender];
                if (balance != 0) {
                    delegatedPerToken[currentDelegate][LPToken] = delegatedPerToken[currentDelegate][LPToken]
                        .sub(balance);
                    delegatedPerToken[delegateToSet][LPToken] = delegatedPerToken[delegateToSet][LPToken]
                        .add(balance);
                }
            }

            delegate[msg.sender] = delegateToSet;
            _delegatedSet.addAddress(delegateToSet);

            emit ChangeDelegate(
                msg.sender,
                currentDelegate,
                delegateToSet
            );

            currentDelegate = delegateToSet;
        }
    }*/

    function claim(
        bool restake)
        external
        checkPause
        updateRewards(msg.sender)
        returns (uint256 bzrxRewardsEarned, uint256 stableCoinRewardsEarned)
    {
        return _claim(restake);
    }

    function claimBzrx()
        external
        checkPause
        updateRewards(msg.sender)
        returns (uint256 bzrxRewardsEarned)
    {
        bzrxRewardsEarned = _claimBzrx(false);

        emit Claim(
            msg.sender,
            bzrxRewardsEarned,
            0
        );
    }

    function claim3Crv()
        external
        checkPause
        updateRewards(msg.sender)
        returns (uint256 stableCoinRewardsEarned)
    {
        stableCoinRewardsEarned = _claim3Crv();

        emit Claim(
            msg.sender,
            0,
            stableCoinRewardsEarned
        );
    }

    function _claim(
        bool restake)
        internal
        returns (uint256 bzrxRewardsEarned, uint256 stableCoinRewardsEarned)
    {
        bzrxRewardsEarned = _claimBzrx(restake);
        stableCoinRewardsEarned = _claim3Crv();

        emit Claim(
            msg.sender,
            bzrxRewardsEarned,
            stableCoinRewardsEarned
        );
    }

    function _claimBzrx(
        bool restake)
        internal
        returns (uint256 bzrxRewardsEarned)
    {
        bzrxRewardsEarned = bzrxRewards[msg.sender];
        if (bzrxRewardsEarned != 0) {
            bzrxRewards[msg.sender] = 0;
            if (restake) {
                _restakeBZRX(
                    msg.sender,
                    bzrxRewardsEarned
                );
            } else {
                if (IERC20(BZRX).balanceOf(address(this)) < bzrxRewardsEarned) {
                    // settle vested BZRX only if needed
                    IVestingToken(vBZRX).claim();
                }

                IERC20(BZRX).transfer(msg.sender, bzrxRewardsEarned);
            }
        }
    }

    function _claim3Crv()
        internal 
        returns (uint256 stableCoinRewardsEarned)
    {
        stableCoinRewardsEarned = stableCoinRewards[msg.sender];
        if (stableCoinRewardsEarned != 0) {
            stableCoinRewards[msg.sender] = 0;
            curve3Crv.transfer(msg.sender, stableCoinRewardsEarned);
        }
    }

    function _restakeBZRX(
        address account,
        uint256 amount)
        internal
    {
        //address currentDelegate = delegate[account];
        _balancesPerToken[BZRX][account] = _balancesPerToken[BZRX][account]
            .add(amount);

        _totalSupplyPerToken[BZRX] = _totalSupplyPerToken[BZRX]
            .add(amount);

        /*delegatedPerToken[currentDelegate][BZRX] = delegatedPerToken[currentDelegate][BZRX]
            .add(amount);*/

        emit Stake(
            account,
            BZRX,
            account, //currentDelegate,
            amount
        );
    }

    function exit()
        public
        // unstake() does a checkPause
    {
        address[] memory tokens = new address[](4);
        uint256[] memory values = new uint256[](4);
        tokens[0] = iBZRX;
        tokens[1] = LPToken;
        tokens[2] = vBZRX;
        tokens[3] = BZRX;
        values[0] = uint256(-1);
        values[1] = uint256(-1);
        values[2] = uint256(-1);
        values[3] = uint256(-1);
        
        unstake(tokens, values); // calls updateRewards
        _claim(false);
    }

    /*function getDelegateVotes(
        uint256 start,
        uint256 count)
        external
        view
        returns (DelegatedTokens[] memory delegateArr)
    {
        uint256 end = start.add(count).min256(_delegatedSet.length());
        if (start >= end) {
            return delegateArr;
        }
        count = end-start;

        uint256 idx = count;
        address user;
        delegateArr = new DelegatedTokens[](idx);
        for (uint256 i = --end; i >= start; i--) {
            user = _delegatedSet.getAddress(i);
            delegateArr[count-(idx--)] = DelegatedTokens({
                user: user,
                BZRX: delegatedPerToken[user][BZRX],
                vBZRX: delegatedPerToken[user][vBZRX],
                iBZRX: delegatedPerToken[user][iBZRX],
                LPToken: delegatedPerToken[user][LPToken],
                totalVotes: delegateBalanceOf(user)
            });

            if (i == 0) {
                break;
            }
        }

        if (idx != 0) {
            count -= idx;
            assembly {
                mstore(delegateArr, count)
            }
        }
    }*/

    modifier updateRewards(address account) {
        uint256 _bzrxPerTokenStored = bzrxPerTokenStored;
        uint256 _stableCoinPerTokenStored = stableCoinPerTokenStored;

        (uint256 bzrxRewardsEarned, uint256 stableCoinRewardsEarned, uint256 bzrxRewardsVesting, uint256 stableCoinRewardsVesting) = _earned(
            account,
            _bzrxPerTokenStored,
            _stableCoinPerTokenStored
        );
        bzrxRewardsPerTokenPaid[account] = _bzrxPerTokenStored;
        stableCoinRewardsPerTokenPaid[account] = _stableCoinPerTokenStored;

        // vesting amounts get updated before sync
        bzrxVesting[account] = bzrxRewardsVesting;
        stableCoinVesting[account] = stableCoinRewardsVesting;

        (bzrxRewards[account], stableCoinRewards[account]) = _syncVesting(
            account,
            bzrxRewardsEarned,
            stableCoinRewardsEarned,
            bzrxRewardsVesting,
            stableCoinRewardsVesting
        );
        vestingLastSync[account] = block.timestamp;

        _;
    }

    function earned(
        address account)
        external
        view
        returns (uint256 bzrxRewardsEarned, uint256 stableCoinRewardsEarned, uint256 bzrxRewardsVesting, uint256 stableCoinRewardsVesting)
    {
        (bzrxRewardsEarned, stableCoinRewardsEarned, bzrxRewardsVesting, stableCoinRewardsVesting) = _earned(
            account,
            bzrxPerTokenStored,
            stableCoinPerTokenStored
        );

        (bzrxRewardsEarned, stableCoinRewardsEarned) = _syncVesting(
            account,
            bzrxRewardsEarned,
            stableCoinRewardsEarned,
            bzrxRewardsVesting,
            stableCoinRewardsVesting
        );

        // discount vesting amounts for vesting time
        uint256 multiplier = vestedBalanceForAmount(
            1e36,
            0,
            block.timestamp
        );
        bzrxRewardsVesting = bzrxRewardsVesting
            .sub(bzrxRewardsVesting
                .mul(multiplier)
                .div(1e36)
            );
        stableCoinRewardsVesting = stableCoinRewardsVesting
            .sub(stableCoinRewardsVesting
                .mul(multiplier)
                .div(1e36)
            );
    }

    function _earned(
        address account,
        uint256 _bzrxPerToken,
        uint256 _stableCoinPerToken)
        internal
        view
        returns (uint256 bzrxRewardsEarned, uint256 stableCoinRewardsEarned, uint256 bzrxRewardsVesting, uint256 stableCoinRewardsVesting)
    {
        uint256 bzrxPerTokenUnpaid = _bzrxPerToken.sub(bzrxRewardsPerTokenPaid[account]);
        uint256 stableCoinPerTokenUnpaid = _stableCoinPerToken.sub(stableCoinRewardsPerTokenPaid[account]);

        bzrxRewardsEarned = bzrxRewards[account];
        stableCoinRewardsEarned = stableCoinRewards[account];
        bzrxRewardsVesting = bzrxVesting[account];
        stableCoinRewardsVesting = stableCoinVesting[account];

        if (bzrxPerTokenUnpaid != 0 || stableCoinPerTokenUnpaid != 0) {
            uint256 value;
            uint256 multiplier;
            uint256 lastSync;

            (uint256 vestedBalance, uint256 vestingBalance) = balanceOfStored(account);

            value = vestedBalance
                .mul(bzrxPerTokenUnpaid);
            value /= 1e36;
            bzrxRewardsEarned = value
                .add(bzrxRewardsEarned);

            value = vestedBalance
                .mul(stableCoinPerTokenUnpaid);
            value /= 1e36;
            stableCoinRewardsEarned = value
                .add(stableCoinRewardsEarned);

            if (vestingBalance != 0 && bzrxPerTokenUnpaid != 0) {
                // add new vesting amount for BZRX
                value = vestingBalance
                    .mul(bzrxPerTokenUnpaid);
                value /= 1e36;
                bzrxRewardsVesting = bzrxRewardsVesting
                    .add(value);

                // true up earned amount to vBZRX vesting schedule
                lastSync = vestingLastSync[account];
                multiplier = vestedBalanceForAmount(
                    1e36,
                    0,
                    lastSync
                );
                value = value
                    .mul(multiplier);
                value /= 1e36;
                bzrxRewardsEarned = bzrxRewardsEarned
                    .add(value);
            }
            if (vestingBalance != 0 && stableCoinPerTokenUnpaid != 0) {
                // add new vesting amount for 3crv
                value = vestingBalance
                    .mul(stableCoinPerTokenUnpaid);
                value /= 1e36;
                stableCoinRewardsVesting = stableCoinRewardsVesting
                    .add(value);

                // true up earned amount to vBZRX vesting schedule
                if (lastSync == 0) {
                    lastSync = vestingLastSync[account];
                    multiplier = vestedBalanceForAmount(
                        1e36,
                        0,
                        lastSync
                    );
                }
                value = value
                    .mul(multiplier);
                value /= 1e36;
                stableCoinRewardsEarned = stableCoinRewardsEarned
                    .add(value);
            }
        }
    }

    function _syncVesting(
        address account,
        uint256 bzrxRewardsEarned,
        uint256 stableCoinRewardsEarned,
        uint256 bzrxRewardsVesting,
        uint256 stableCoinRewardsVesting)
        internal
        view
        returns (uint256, uint256)
    {
        uint256 lastVestingSync = vestingLastSync[account];

        if (lastVestingSync != block.timestamp) {
            uint256 rewardsVested;
            uint256 multiplier = vestedBalanceForAmount(
                1e36,
                lastVestingSync,
                block.timestamp
            );

            if (bzrxRewardsVesting != 0) {
                rewardsVested = bzrxRewardsVesting
                    .mul(multiplier)
                    .div(1e36);
                bzrxRewardsEarned += rewardsVested;
            }

            if (stableCoinRewardsVesting != 0) {
                rewardsVested = stableCoinRewardsVesting
                    .mul(multiplier)
                    .div(1e36);
                stableCoinRewardsEarned += rewardsVested;
            }

            uint256 vBZRXBalance = _balancesPerToken[vBZRX][account];
            if (vBZRXBalance != 0) {
                // add vested BZRX to rewards balance
                rewardsVested = vBZRXBalance
                    .mul(multiplier)
                    .div(1e36);
                bzrxRewardsEarned += rewardsVested;
            }
        }

        return (bzrxRewardsEarned, stableCoinRewardsEarned);
    }

    // note: anyone can contribute rewards to the contract
    function addDirectRewards(
        address[] calldata accounts,
        uint256[] calldata bzrxAmounts,
        uint256[] calldata stableCoinAmounts)
        external
        checkPause
        returns (uint256 bzrxTotal, uint256 stableCoinTotal)
    {
        require(accounts.length == bzrxAmounts.length && accounts.length == stableCoinAmounts.length, "count mismatch");

        for (uint256 i = 0; i < accounts.length; i++) {
            bzrxRewards[accounts[i]] = bzrxRewards[accounts[i]].add(bzrxAmounts[i]);
            bzrxTotal = bzrxTotal.add(bzrxAmounts[i]);
            stableCoinRewards[accounts[i]] = stableCoinRewards[accounts[i]].add(stableCoinAmounts[i]);
            stableCoinTotal = stableCoinTotal.add(stableCoinAmounts[i]);
        }
        if (bzrxTotal != 0) {
            IERC20(BZRX).transferFrom(msg.sender, address(this), bzrxTotal);
        }
        if (stableCoinTotal != 0) {
            curve3Crv.transferFrom(msg.sender, address(this), stableCoinTotal);
        }
    }

    // note: anyone can contribute rewards to the contract
    function addRewards(
        uint256 newBZRX,
        uint256 newStableCoin)
        external
        checkPause
    {
        if (newBZRX != 0 || newStableCoin != 0) {
            _addRewards(newBZRX, newStableCoin);
            if (newBZRX != 0) {
                IERC20(BZRX).transferFrom(msg.sender, address(this), newBZRX);
            }
            if (newStableCoin != 0) {
                curve3Crv.transferFrom(msg.sender, address(this), newStableCoin);
            }
        }
    }

    function _addRewards(
        uint256 newBZRX,
        uint256 newStableCoin)
        internal
    {
        (vBZRXWeightStored, iBZRXWeightStored, LPTokenWeightStored) = getVariableWeights();

        uint256 totalTokens = totalSupplyStored();
        require(totalTokens != 0, "nothing staked");

        bzrxPerTokenStored = newBZRX
            .mul(1e36)
            .div(totalTokens)
            .add(bzrxPerTokenStored);

        stableCoinPerTokenStored = newStableCoin
            .mul(1e36)
            .div(totalTokens)
            .add(stableCoinPerTokenStored);

        lastRewardsAddTime = block.timestamp;

        emit AddRewards(
            msg.sender,
            newBZRX,
            newStableCoin
        );
    }

    function _addAltRewards(address token, uint256 amount) internal {

        address poolAddress = (token == SUSHI)?LPToken:token;

        uint256 totalSupply = _totalSupplyPerToken[poolAddress];
        require(totalSupply != 0, "no deposits");

        uint256 _prevAltRewardsPerShare = 0;
        uint256[] memory _altRewardsRounds = altRewardsRounds[token];
        if (_altRewardsRounds.length > 0) {
            _prevAltRewardsPerShare = _altRewardsRounds[_altRewardsRounds.length - 1];
        }

        uint256 _currentAltRewardsPerShare = amount.mul(1e12).div(totalSupply);
        uint256 _rewardsPerShare = _currentAltRewardsPerShare.add(_prevAltRewardsPerShare);
        altRewardsRounds[token].push(_rewardsPerShare);

        emit AddAltRewards(msg.sender, token, amount);
    }

    function getVariableWeights()
        public
        view
        returns (uint256 vBZRXWeight, uint256 iBZRXWeight, uint256 LPTokenWeight)
    {
        uint256 totalVested = vestedBalanceForAmount(
            _startingVBZRXBalance,
            0,
            block.timestamp
        );

        vBZRXWeight = SafeMath.mul(_startingVBZRXBalance - totalVested, 1e18) // overflow not possible
            .div(_startingVBZRXBalance);

        iBZRXWeight = _calcIBZRXWeight();

        uint256 lpTokenSupply = _totalSupplyPerToken[LPToken];
        if (lpTokenSupply != 0) {
            // staked LP tokens are assumed to represent the total unstaked supply (circulated supply - staked BZRX)
            uint256 normalizedLPTokenSupply = initialCirculatingSupply +
                totalVested -
                _totalSupplyPerToken[BZRX];

            LPTokenWeight = normalizedLPTokenSupply
                .mul(1e18)
                .div(lpTokenSupply);
        }
    }

    function _calcIBZRXWeight()
        internal
        view
        returns (uint256)
    {
        return IERC20(BZRX).balanceOf(iBZRX)
            .mul(1e50)
            .div(IERC20(iBZRX).totalSupply());
    }

    function balanceOfByAsset(
        address token,
        address account)
        public
        view
        returns (uint256 balance)
    {
        balance = _balancesPerToken[token][account];
    }

    function balanceOfByAssets(
        address account)
        external
        view
        returns (
            uint256 bzrxBalance,
            uint256 iBZRXBalance,
            uint256 vBZRXBalance,
            uint256 LPTokenBalance,
            uint256 LPTokenBalanceOld
        )
    {
        return (
            balanceOfByAsset(BZRX, account),
            balanceOfByAsset(iBZRX, account),
            balanceOfByAsset(vBZRX, account),
            balanceOfByAsset(LPToken, account),
            balanceOfByAsset(LPTokenOld, account)
        );
    }

    function balanceOfStored(
        address account)
        public
        view
        returns (uint256 vestedBalance, uint256 vestingBalance)
    {
        uint256 balance = _balancesPerToken[vBZRX][account];
        if (balance != 0) {
            vestingBalance = _balancesPerToken[vBZRX][account]
                .mul(vBZRXWeightStored)
                .div(1e18);
        }

        vestedBalance = _balancesPerToken[BZRX][account];

        balance = _balancesPerToken[iBZRX][account];
        if (balance != 0) {
            vestedBalance = balance
                .mul(iBZRXWeightStored)
                .div(1e50)
                .add(vestedBalance);
        }

        balance = _balancesPerToken[LPToken][account];
        if (balance != 0) {
            vestedBalance = balance
                .mul(LPTokenWeightStored)
                .div(1e18)
                .add(vestedBalance);
        }
    }

    function totalSupplyByAsset(
        address token)
        external
        view
        returns (uint256)
    {
        return _totalSupplyPerToken[token];
    }

    function totalSupplyStored()
        public
        view
        returns (uint256 supply)
    {
        supply = _totalSupplyPerToken[vBZRX]
            .mul(vBZRXWeightStored)
            .div(1e18);

        supply = _totalSupplyPerToken[BZRX]
            .add(supply);

        supply = _totalSupplyPerToken[iBZRX]
            .mul(iBZRXWeightStored)
            .div(1e50)
            .add(supply);

        supply = _totalSupplyPerToken[LPToken]
            .mul(LPTokenWeightStored)
            .div(1e18)
            .add(supply);
    }

    function vestedBalanceForAmount(
        uint256 tokenBalance,
        uint256 lastUpdate,
        uint256 vestingEndTime)
        public
        view
        returns (uint256 vested)
    {
        vestingEndTime = vestingEndTime.min256(block.timestamp);
        if (vestingEndTime > lastUpdate) {
            if (vestingEndTime <= vestingCliffTimestamp ||
                lastUpdate >= vestingEndTimestamp) {
                // time cannot be before vesting starts
                // OR all vested token has already been claimed
                return 0;
            }
            if (lastUpdate < vestingCliffTimestamp) {
                // vesting starts at the cliff timestamp
                lastUpdate = vestingCliffTimestamp;
            }
            if (vestingEndTime > vestingEndTimestamp) {
                // vesting ends at the end timestamp
                vestingEndTime = vestingEndTimestamp;
            }

            uint256 timeSinceClaim = vestingEndTime.sub(lastUpdate);
            vested = tokenBalance.mul(timeSinceClaim) / vestingDurationAfterCliff; // will never divide by 0
        }
    }


    // Governance Logic //

    function votingBalanceOf(
        address account,
        uint256 proposalId)
        public
        view
        returns (uint256 totalVotes)
    {
        return _votingBalanceOf(account, _proposalState[proposalId]);
    }

    function votingBalanceOfNow(
        address account)
        public
        view
        returns (uint256 totalVotes)
    {
        return _votingBalanceOf(account, _getProposalState());
    }

    function _setProposalVals(
        address account,
        uint256 proposalId)
        public
        returns (uint256)
    {
        require(msg.sender == governor, "unauthorized");
        require(_proposalState[proposalId].proposalTime == 0, "proposal exists");
        ProposalState memory newProposal = _getProposalState();
        _proposalState[proposalId] = newProposal;

        return _votingBalanceOf(account, newProposal);
    }

    function _getProposalState()
        internal
        view
        returns (ProposalState memory)
    {
        return ProposalState({
            proposalTime: block.timestamp - 1,
            iBZRXWeight: _calcIBZRXWeight(),
            lpBZRXBalance: IERC20(BZRX).balanceOf(LPToken),
            lpTotalSupply: IERC20(LPToken).totalSupply()
        });
    }

    function _votingBalanceOf(
        address account,
        ProposalState memory proposal)
        internal
        view
        returns (uint256 totalVotes)
    {
        uint256 _vestingLastSync = vestingLastSync[account];
        if (proposal.proposalTime == 0 || _vestingLastSync > proposal.proposalTime - 1) {
            return 0;
        }

        uint256 _vBZRXBalance = _balancesPerToken[vBZRX][account];
        if (_vBZRXBalance != 0) {
            // staked vBZRX is prorated based on total vested
            totalVotes = _vBZRXBalance
                .mul(_startingVBZRXBalance -
                    vestedBalanceForAmount( // overflow not possible
                        _startingVBZRXBalance,
                        0,
                        proposal.proposalTime
                    )
                ).div(_startingVBZRXBalance);

            // user is attributed a staked balance of vested BZRX, from their last update to the present
            totalVotes = vestedBalanceForAmount(
                _vBZRXBalance,
                _vestingLastSync,
                proposal.proposalTime
            ).add(totalVotes);
        }

        totalVotes = _balancesPerToken[BZRX][account]
            .add(bzrxRewards[account]) // unclaimed BZRX rewards count as votes
            .add(totalVotes);

        totalVotes = _balancesPerToken[iBZRX][account]
            .mul(proposal.iBZRXWeight)
            .div(1e50)
            .add(totalVotes);

        // LPToken votes are measured based on amount of underlying BZRX staked
        totalVotes = proposal.lpBZRXBalance
            .mul(_balancesPerToken[LPToken][account])
            .div(proposal.lpTotalSupply)
            .add(totalVotes);
    }

    // OnlyOwner functions

    function togglePause(
        bool _isPaused)
        external
        onlyOwner
    {
        isPaused = _isPaused;
    }

    function setFundsWallet(
        address _fundsWallet)
        external
        onlyOwner
    {
        fundsWallet = _fundsWallet;
    }

    function setGovernor(
        address _governor)
        external
        onlyOwner
    {
        governor = _governor;
    }

    function setFeeTokens(
        address[] calldata tokens)
        external
        onlyOwner
    {
        currentFeeTokens = tokens;
    }

    // path should start with the asset to swap and end with BZRX
    // only one path allowed per asset
    // ex: asset -> WETH -> BZRX
    function setPaths(
        address[][] calldata paths)
        external
        onlyOwner
    {
        address[] memory path;
        for (uint256 i = 0; i < paths.length; i++) {
            path = paths[i];
            require(path.length >= 2 &&
                path[0] != path[path.length - 1] &&
                path[path.length - 1] == BZRX,
                "invalid path"
            );
            
            // check that the path exists
            uint256[] memory amountsOut = uniswapRouter.getAmountsOut(1e10, path);
            require(amountsOut[amountsOut.length - 1] != 0, "path does not exist");
            
            swapPaths[path[0]] = path;
            IERC20(path[0]).safeApprove(address(uniswapRouter), 0);
            IERC20(path[0]).safeApprove(address(uniswapRouter), uint256(-1));
        }
    }

    /*
    // commenting to reduce compile size
    function setCurveApproval()
        external
        onlyOwner
    {
        IERC20(DAI).safeApprove(address(curve3pool), 0);
        IERC20(DAI).safeApprove(address(curve3pool), uint256(-1));
        IERC20(USDC).safeApprove(address(curve3pool), 0);
        IERC20(USDC).safeApprove(address(curve3pool), uint256(-1));
        IERC20(USDT).safeApprove(address(curve3pool), 0);
        IERC20(USDT).safeApprove(address(curve3pool), uint256(-1));
    }*/

    function setRewardPercent(
        uint256 _rewardPercent)
        external
        onlyOwner
    {
        require(_rewardPercent <= 1e20, "value too high");
        rewardPercent = _rewardPercent;
    }

    function setMaxUniswapDisagreement(
        uint256 _maxUniswapDisagreement)
        external
        onlyOwner
    {
        require(_maxUniswapDisagreement != 0, "invalid param");
        maxUniswapDisagreement = _maxUniswapDisagreement;
    }

    function setMaxCurveDisagreement(
        uint256 _maxCurveDisagreement)
        external
        onlyOwner
    {
        require(_maxCurveDisagreement != 0, "invalid param");
        maxCurveDisagreement = _maxCurveDisagreement;
    }

    function setCallerRewardDivisor(
        uint256 _callerRewardDivisor)
        external
        onlyOwner
    {
        require(_callerRewardDivisor != 0, "invalid param");
        callerRewardDivisor = _callerRewardDivisor;
    }
}
