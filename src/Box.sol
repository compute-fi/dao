// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract Box is Ownable {
    uint256 private s_value;

    event ValueChanged(uint256 oldValue, uint256 newValue);

    constructor() Ownable(msg.sender) {} // making the initial owner to be the deployer of this smart contract.

    function store(uint256 _value) public onlyOwner {
        emit ValueChanged(s_value, _value);
        s_value = _value;
    }

    function getNumber() external view returns (uint256) {
        return s_value;
    }
}
