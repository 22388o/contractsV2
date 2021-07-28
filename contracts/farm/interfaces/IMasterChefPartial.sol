/**
 * Copyright 2017-2020, bZeroX, LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0.
 */

// SPDX-License-Identifier: APACHE 2.0

pragma solidity >=0.6.0 <0.8.0;


interface IMasterChefPartial {
    function addExternalReward(
        uint256 _amount)
        external;

    function addAltReward()
        external
        payable;

    event AddExternalReward(
        address indexed sender,
        uint256 indexed pid,
        uint256 amount
    );

    event AddAltReward(
        address indexed sender,
        uint256 indexed pid,
        uint256 amount
    );
}
