// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { ISelfVerificationRoot } from "../interfaces/ISelfVerificationRoot.sol";

abstract contract SelfVerificationRoot is ISelfVerificationRoot {
    address public hubAddress;
    bytes32 public configId;

    constructor(address _hubAddress, bytes32 _configId) {
        hubAddress = _hubAddress;
        configId = _configId;
    }

    /**
     * @notice Simulates proof verification.
     * @dev If the first byte of proof is 0x99, it simulates verification failure.
     */
    function verifySelfProof(
        ISelfVerificationRoot.GenericDiscloseOutputV2 calldata output,
        bytes calldata proof,
        bytes calldata userData
    ) external {
        // Mock check: if proof starts with 0x99, revert
        if (proof.length > 0 && proof[0] == 0x99) {
            revert("SelfVerificationRoot: Invalid ZK proof");
        }
        
        // Execute custom verification callback hook
        customVerificationHook(output, userData);
    }

    function customVerificationHook(
        ISelfVerificationRoot.GenericDiscloseOutputV2 memory output,
        bytes memory userData
    ) internal virtual;
}
