// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { Script } from "forge-std/Script.sol";
import { SelfVerifier } from "../src/SelfVerifier.sol";

contract DeployScript is Script {
    function run() external returns (SelfVerifier) {
        // Load private key from environment variable, default to Anvil private key
        uint256 deployerPrivateKey = vm.envOr("PRIVATE_KEY", uint256(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80));
        
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
