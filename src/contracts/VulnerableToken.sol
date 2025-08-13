// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VulnerableToken {
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowances;
    
    string public name = "VulnerableToken";
    string public symbol = "VUL";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    address public owner;
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }
    
    constructor(uint256 _totalSupply) {
        totalSupply = _totalSupply;
        balances[msg.sender] = _totalSupply;
        owner = msg.sender;
    }
    
    // Reentrancy vulnerability
    function withdraw() external {
        uint256 balance = balances[msg.sender];
        require(balance > 0, "No balance");
        
        // External call before state change - reentrancy risk
        (bool success, ) = msg.sender.call{value: balance}("");
        require(success, "Transfer failed");
        
        balances[msg.sender] = 0; // State change after external call
    }
    
    // Integer overflow vulnerability (pre-Solidity 0.8.0 style)
    function unsafeAdd(uint256 a, uint256 b) public pure returns (uint256) {
        // In older versions this could overflow
        unchecked {
            return a + b;
        }
    }
    
    // Access control vulnerability
    function mint(address to, uint256 amount) external {
        // Missing onlyOwner modifier - anyone can mint
        balances[to] += amount;
        totalSupply += amount;
    }
    
    // Timestamp dependence vulnerability
    function timeBasedAction() external view returns (bool) {
        // Using block.timestamp for critical logic
        return block.timestamp % 2 == 0;
    }
    
    // Unchecked external call
    function unsafeTransfer(address to, uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        
        balances[msg.sender] -= amount;
        balances[to] += amount;
        
        // Unchecked external call
        to.call(abi.encodeWithSignature("notify(uint256)", amount));
    }
    
    // Denial of Service through gas limit
    function processLargeArray(address[] memory addresses) external {
        // Unbounded loop - DoS vulnerability
        for (uint i = 0; i < addresses.length; i++) {
            balances[addresses[i]] += 1;
        }
    }
    
    // Information disclosure
    function getSecretData() external view returns (bytes32) {
        // Private data on blockchain is not actually private
        bytes32 secret = keccak256(abi.encodePacked(block.timestamp, msg.sender));
        return secret;
    }
    
    // Weak randomness
    function randomNumber() external view returns (uint256) {
        // Predictable randomness using block properties
        return uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % 100;
    }
    
    // Fallback function without proper checks
    fallback() external payable {
        // Accept any call and payment without validation
        balances[msg.sender] += msg.value;
    }
    
    receive() external payable {
        balances[msg.sender] += msg.value;
    }
}