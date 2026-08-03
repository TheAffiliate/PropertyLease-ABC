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

    // --- ADDITIONAL STATE VARIABLES ---
    // 5. Store the deployer's address to establish the landlord.
    address public owner; 

    // --- EVENTS ---
    // 6. Events allow light clients (like frontends) to listen for changes on the blockchain efficiently.
    event LeaseCreated(uint256 indexed propertyId, address indexed tenant);

    // --- CONSTRUCTOR ---
    // 7. The constructor runs exactly once during contract deployment.
    constructor() {
        // msg.sender is a globally available variable in Solidity representing the address calling the function.
        // Here, it sets whoever deploys the contract as the landlord.
        owner = msg.sender; 
    }

    // --- MODIFIERS ---
    // 8. Modifiers act as reusable security checks that you can attach to various functions.
    
    // This modifier restricts function access to only the landlord.
    modifier onlyOwner() {
        require(msg.sender == owner, "Access Denied: Caller is not the landlord");
        // The underscore tells Solidity to return to the function and execute the rest of the code.
        _; 
    }

    // This modifier restricts function access to only the specific tenant of a given property.
    modifier onlyTenant(uint256 _propertyId) {
        require(msg.sender == propertyLeases[_propertyId].tenantAddress, "Access Denied: Caller is not the tenant");
        _;
    }

    // --- CORE FUNCTIONS ---
    
    // 9. Creating the Lease: This function allows the landlord to set up a new agreement.
    // It requires the property ID, tenant's wallet address, rent cost, and deposit amount.
    // We attach the 'onlyOwner' modifier so ONLY the deployer (landlord) can execute this.
    function createLease(
        uint256 _propertyId, 
        address _tenantAddress, 
        uint256 _rentAmount, 
        uint256 _securityDeposit
    ) public onlyOwner {
        
        // Safety Check: Ensure a lease doesn't already exist for this property ID to prevent accidental overwriting.
        require(!propertyLeases[_propertyId].isActive, "Error: An active lease already exists for this property");

        // Populate the Lease struct and save it to the mapping under the provided _propertyId.
        propertyLeases[_propertyId] = Lease({
            tenantAddress: _tenantAddress,
            rentAmount: _rentAmount,
            securityDeposit: _securityDeposit,
            // block.timestamp is a global variable for the current time. 
            // We set the initial payment due date to the exact moment the lease is created.
            nextPaymentDueDate: block.timestamp, 
            isActive: true
        });

        // Emit the event to create a searchable log on the blockchain
        emit LeaseCreated(_propertyId, _tenantAddress);
    }

    // --- ESCROW & FINANCIAL TRACKING ---
    // 10. Track the security deposits currently locked in the contract's escrow.
    mapping(uint256 => uint256) public deposits;

    // 11. Security Deposit Payment: Allows the assigned tenant to fund the escrow.
    // The 'payable' keyword is mandatory for any function that receives ETH.
    // We attach the 'onlyTenant' modifier so random wallets cannot pay this deposit.
    function paySecurityDeposit(uint256 _propertyId) public payable onlyTenant(_propertyId) {
        
        // Use the 'storage' keyword to reference the specific lease in our mapping.
        // This is cheaper on gas than copying it to 'memory'.
        Lease storage currentLease = propertyLeases[_propertyId];

        // Safety Check 1: Ensure the lease is actually active.
        require(currentLease.isActive, "Error: This lease is no longer active");
        
        // Safety Check 2: Require the exact deposit amount (msg.value represents the ETH sent).
        require(msg.value == currentLease.securityDeposit, "Error: Must send the exact security deposit amount");
        
        // Safety Check 3: Ensure the deposit hasn't already been paid to prevent double-charging.
        require(deposits[_propertyId] == 0, "Error: Security deposit has already been paid for this property");

        // Update our mapping to securely track that the contract now holds these funds.
        deposits[_propertyId] = msg.value;
    }

}