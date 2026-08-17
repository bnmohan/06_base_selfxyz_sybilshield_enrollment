// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { Script } from "forge-std/Script.sol";
import { SelfVerifier } from "../src/SelfVerifier.sol";

contract DeployScript is Script {
    function run() external returns (SelfVerifier) {
        // Exception handling: check if PRIVATE_KEY is defined in the environment
        string memory privateKeyString = vm.envOr("PRIVATE_KEY", string(""));
        if (bytes(privateKeyString).length == 0) {
            revert("Deployment Error: PRIVATE_KEY environment variable is not defined or empty in your shell environment.");
        }
        
        // Normalize the hex key by ensuring it has the "0x" prefix
        bytes memory keyBytes = bytes(privateKeyString);
        string memory normalizedKey;
        if (keyBytes.length >= 2 && keyBytes[0] == "0" && keyBytes[1] == "x") {
            normalizedKey = privateKeyString;
        } else {
            normalizedKey = string.concat("0x", privateKeyString);
        }
        
        uint256 deployerPrivateKey = uint256(vm.parseBytes32(normalizedKey));
        
        // Load Self.xyz parameters, default to address(0) and bytes32(0)
        address hubAddress = vm.envOr("SELF_HUB_ADDRESS", address(0));
        bytes32 configId = vm.envOr("SELF_CONFIG_ID", bytes32(0));
        
        vm.startBroadcast(deployerPrivateKey);
        
        SelfVerifier verifier = new SelfVerifier(
            hubAddress,
            configId
        );
        
        vm.stopBroadcast();
        return verifier;
    }
}
