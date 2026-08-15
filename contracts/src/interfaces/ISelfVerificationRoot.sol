// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface ISelfVerificationRoot {
    struct GenericDiscloseOutputV2 {
        bytes32 attestationId;
        uint256 userIdentifier;
        uint256 nullifier;
        string issuingState;
    }
}
