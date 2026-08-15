// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { Test } from "forge-std/Test.sol";
import { SelfVerifier } from "../src/SelfVerifier.sol";
import { ISelfVerificationRoot } from "../src/interfaces/ISelfVerificationRoot.sol";

contract SelfVerifierTest is Test {
    SelfVerifier public verifier;
    
    address public hubAddress = address(0xABC);
    bytes32 public configId = bytes32(uint256(123456));
    
    address public user1 = address(0x1);
    address public user2 = address(0x2);

    function setUp() public {
        verifier = new SelfVerifier(hubAddress, configId);
    }

    function test_RegisterHuman_Success() public {
        vm.prank(user1);
        
        // Define mock disclose output
        ISelfVerificationRoot.GenericDiscloseOutputV2 memory output = ISelfVerificationRoot.GenericDiscloseOutputV2({
            attestationId: bytes32("E_PASSPORT"),
            userIdentifier: 999999,
            nullifier: 888888,
            issuingState: "IND"
        });
        
        bytes memory proof = abi.encodePacked(uint8(0x01)); // valid proof representation
        bytes memory userData = abi.encode(user1);
        
        vm.expectEmit(true, true, false, true);
        emit SelfVerifier.HumanRegistered(user1, 888888, "IND");

        verifier.verifySelfProof(output, proof, userData);

        assertTrue(verifier.isHuman(user1));
        assertTrue(verifier.nullifierHashes(888888));
        assertEq(verifier.userIdentifiers(user1), 999999);
        assertEq(verifier.userCountries(user1), "IND");
    }

    function test_RegisterHuman_RevertIfDoubleClaim() public {
        // First registration
        ISelfVerificationRoot.GenericDiscloseOutputV2 memory output = ISelfVerificationRoot.GenericDiscloseOutputV2({
            attestationId: bytes32("E_PASSPORT"),
            userIdentifier: 999999,
            nullifier: 888888,
            issuingState: "IND"
        });
        bytes memory proof = abi.encodePacked(uint8(0x01));
        bytes memory userData = abi.encode(user1);
        
        verifier.verifySelfProof(output, proof, userData);
        
        // Attempting to register again with same user
        vm.expectRevert("Address already registered");
        verifier.verifySelfProof(output, proof, userData);
    }

    function test_RegisterHuman_RevertIfDuplicateNullifier() public {
        // First registration
        ISelfVerificationRoot.GenericDiscloseOutputV2 memory output1 = ISelfVerificationRoot.GenericDiscloseOutputV2({
            attestationId: bytes32("E_PASSPORT"),
            userIdentifier: 999999,
            nullifier: 888888,
            issuingState: "IND"
        });
        bytes memory proof = abi.encodePacked(uint8(0x01));
        bytes memory userData1 = abi.encode(user1);
        verifier.verifySelfProof(output1, proof, userData1);
        
        // Attempting to register different address with same nullifier (Sybil attack)
        ISelfVerificationRoot.GenericDiscloseOutputV2 memory output2 = ISelfVerificationRoot.GenericDiscloseOutputV2({
            attestationId: bytes32("E_PASSPORT"),
            userIdentifier: 999999,
            nullifier: 888888, // same nullifier
            issuingState: "IND"
        });
        bytes memory userData2 = abi.encode(user2);
        
        vm.expectRevert("Identity already registered");
        verifier.verifySelfProof(output2, proof, userData2);
    }

    function test_RegisterHuman_RevertIfInvalidProof() public {
        ISelfVerificationRoot.GenericDiscloseOutputV2 memory output = ISelfVerificationRoot.GenericDiscloseOutputV2({
            attestationId: bytes32("E_PASSPORT"),
            userIdentifier: 999999,
            nullifier: 888888,
            issuingState: "IND"
        });
        
        // Proof starting with 0x99 triggers revert in mock base
        bytes memory invalidProof = abi.encodePacked(uint8(0x99));
        bytes memory userData = abi.encode(user1);
        
        vm.expectRevert("SelfVerificationRoot: Invalid ZK proof");
        verifier.verifySelfProof(output, invalidProof, userData);
    }
}
