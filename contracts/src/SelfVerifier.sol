// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { SelfVerificationRoot } from "./mocks/SelfVerificationRoot.sol";
import { ISelfVerificationRoot } from "./interfaces/ISelfVerificationRoot.sol";

/**
 * @title SelfVerifier
 * @notice Registers unique human users via Self.xyz identity verification.
 */
contract SelfVerifier is SelfVerificationRoot {
    // Mapping: walletAddress => isHuman (wallet registered to a verified human)
    mapping(address => bool) public isHuman;

    // Mapping: nullifier => hasRegistered (ensures a human identity is only used once)
    mapping(uint256 => bool) public nullifierHashes;

    // Mapping: walletAddress => userIdentifier (link wallet to verified unique user ID)
    mapping(address => uint256) public userIdentifiers;

    // Mapping: walletAddress => issuingState (stores user's issuing country)
    mapping(address => string) public userCountries;

    // Mapping: walletAddress => nullifier (used for reset functionality)
    mapping(address => uint256) public userNullifiers;

    event HumanRegistered(address indexed user, uint256 indexed nullifier, string issuingState);
    event RegistrationReset(address indexed user);

    constructor(address _hubAddress, bytes32 _configId) SelfVerificationRoot(_hubAddress, _configId) {}

    /**
     * @notice Callback hook executed upon successful proof verification by the base contract.
     * @param output The disclosed identity parameters from the ZK proof.
     * @param userData The extra payload containing the wallet address.
     */
    function customVerificationHook(
        ISelfVerificationRoot.GenericDiscloseOutputV2 memory output,
        bytes memory userData
    ) internal override {
        // 1. Decode user wallet from the metadata payload
        address userWallet = abi.decode(userData, (address));
        require(userWallet != address(0), "Invalid user wallet");

        // 2. Ensure this wallet address isn't already registered
        require(!isHuman[userWallet], "Address already registered");

        // 3. Ensure this specific identity hasn't been registered yet (Sybil protection)
        require(!nullifierHashes[output.nullifier], "Identity already registered");

        // 4. Save registration state
        nullifierHashes[output.nullifier] = true;
        isHuman[userWallet] = true;
        userIdentifiers[userWallet] = output.userIdentifier;
        userCountries[userWallet] = output.issuingState;
        userNullifiers[userWallet] = output.nullifier;

        emit HumanRegistered(userWallet, output.nullifier, output.issuingState);
    }

    /**
     * @notice Reset registration state for testing / demo purposes.
     * @param user Wallet address to reset.
     */
    function resetRegistration(address user) external {
        uint256 nullifier = userNullifiers[user];
        if (nullifier != 0) {
            nullifierHashes[nullifier] = false;
            userNullifiers[user] = 0;
        }
        isHuman[user] = false;
        userIdentifiers[user] = 0;
        userCountries[user] = "";

        emit RegistrationReset(user);
    }
}
