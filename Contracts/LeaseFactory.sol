// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// 1. Import your original contract
import "./PropertyLease.sol";

contract LeaseFactory {
    
    // 2. Track deployed portfolios by the landlord's wallet address
    mapping(address => PropertyLease[]) public landlordPortfolios;

    // 3. Deploy a new portfolio
    function createLeasePortfolio() public {
        // Use the 'new' keyword to deploy a fresh PropertyLease contract.
        // We pass 'msg.sender' into the constructor so the human caller becomes the owner.
        PropertyLease newPortfolio = new PropertyLease(msg.sender);

        // Store the newly deployed contract in the landlord's array
        landlordPortfolios[msg.sender].push(newPortfolio);
    }

    // 4. Helper function to fetch a landlord's specific portfolio
    function getPortfolio(address _landlord, uint256 _index) public view returns (PropertyLease) {
        return landlordPortfolios[_landlord][_index];
    }
}