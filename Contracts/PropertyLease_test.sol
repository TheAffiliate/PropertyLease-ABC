// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// Import Remix testing library and your smart contract
import "remix_tests.sol";
import "./PropertyLease.sol";

contract PropertyLeaseTest {
    PropertyLease propertyLease;
    
    // Define test addresses
    address landlord = address(this);
    address tenant = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;

    /// #section: Lifecycle
    /// Runs before each test function is executed
    function beforeEach() public {
        propertyLease = new PropertyLease(landlord);
    }

    /// #section: Tests
    /// Test 1: Verify the constructor assigns the correct owner
    function testInitialOwner() public {
        Assert.equal(propertyLease.owner(), landlord, "Error: Owner should match the deploying address");
    }

    /// Test 2: Verify the landlord can successfully create a lease
    function testCreateLease() public {
        uint256 propertyId = 1;
        uint256 rentAmount = 2500;
        uint256 deposit = 800;

        // Execute creation
        propertyLease.createLease(propertyId, tenant, rentAmount, deposit);

        // Fetch the struct data from the mapping
        (
            address tenantAddr, 
            uint256 rent, 
            uint256 secDeposit, , 
            bool isActive
        ) = propertyLease.propertyLeases(propertyId);

        // Assertions to verify correct state storage
        Assert.equal(tenantAddr, tenant, "Error: Tenant address does not match");
        Assert.equal(rent, rentAmount, "Error: Rent amount does not match");
        Assert.equal(secDeposit, deposit, "Error: Security deposit does not match");
        Assert.equal(isActive, true, "Error: Lease should be active upon creation");
    }
}