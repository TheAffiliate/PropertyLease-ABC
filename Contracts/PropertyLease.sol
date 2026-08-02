// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

// 2. Contract Definition: The main building block, similar to a class in object-oriented programming.
contract PropertyLease {

    // --- STRUCTS ---
    // 3. Structs allow you to create custom data types. 
    // Here we bundle all the attributes that make up a single lease agreement.
    struct Lease {
        address tenantAddress;       // The Web3 wallet address of the tenant
        uint256 rentAmount;          // The monthly rent cost (stored in Wei)
        uint256 securityDeposit;     // The initial deposit required (stored in Wei)
        uint256 nextPaymentDueDate;  // A Unix timestamp representing when the next payment is required
        bool isActive;               // A simple true/false flag to check if the lease is currently valid
    }

    // --- STATE VARIABLES ---
    // 4. Mappings act like hash tables or dictionaries.
    // This mapping takes a unique property ID (a uint256 number) and returns the corresponding Lease struct.
    // Making it 'public' automatically generates a getter function so we can easily look up lease details.
    mapping(uint256 => Lease) public propertyLeases;

}