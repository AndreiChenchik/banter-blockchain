// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {BanterCoin} from "src/BanterCoin.sol";

contract BanterCoinScript is Script {
    address author = vm.envAddress("KEY_ADDRESS");

    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        address recipient = author;
        BanterCoin instance = new BanterCoin(recipient);
        console.log("Contract deployed to %s", address(instance));
        vm.stopBroadcast();
    }
}
