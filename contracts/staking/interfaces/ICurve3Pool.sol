/**
 * Copyright 2017-2020, bZeroX, LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0.
 */

pragma solidity 0.5.17;


interface ICurve3Pool {
    function add_liquidity(
        uint256[3] calldata amounts,
        uint256 min_mint_amount)
        external;
}
