// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import {Script} from "lib/forge-std/src/Script.sol";
import {console} from "lib/forge-std/src/console.sol";
import {ERC20} from "../src/ERC20.sol";

contract ERC20Deploy is Script {
    function run() public {
        vm.startBroadcast();

        // address owner = vm.envAddress("OWNER");

        ERC20 erc20 = new ERC20();
        console.log("ERC20 contract deployed at: ", address(erc20));

        vm.stopBroadcast();
    }
}
