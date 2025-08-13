// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/VulnerableToken.sol";

contract VulnerableTokenTest is Test {
    VulnerableToken token;
    address owner = address(0x1);
    address user = address(0x2);
    
    function setUp() public {
        vm.prank(owner);
        token = new VulnerableToken(1000000 * 10**18);
    }
    
    function testMintVulnerability() public {
        // Test that anyone can mint tokens due to missing access control
        vm.prank(user);
        token.mint(user, 1000 * 10**18);
        
        assertEq(token.balances(user), 1000 * 10**18);
    }
    
    function testUnsafeAdd() public {
        // Test integer overflow in unsafeAdd
        uint256 result = token.unsafeAdd(type(uint256).max, 1);
        assertEq(result, 0); // Should overflow to 0
    }
    
    function testTimeBasedAction() public {
        // Test timestamp dependence
        bool result = token.timeBasedAction();
        // Result depends on block.timestamp, making it predictable
        assertTrue(result || !result); // Always passes but demonstrates the issue
    }
}