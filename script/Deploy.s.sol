// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/VulnerableToken.sol";

contract DeployScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        
        VulnerableToken token = new VulnerableToken(1000000 * 10**18);
        
        console.log("VulnerableToken deployed to:", address(token));
        
        vm.stopBroadcast();
    }
}