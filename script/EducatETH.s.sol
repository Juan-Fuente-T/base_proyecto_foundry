// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {EducatETH} from "../src/EducatETH.sol";

contract EducatETHDeploy is Script {
    function run() public {
        vm.startBroadcast();

        address owner = vm.envAddress("OWNER");
        
        EducatETH educatETH = new EducatETH(owner);
        console.log("EducatETH contract deployed at: ", address(educatETH));

        vm.stopBroadcast();
    }
}