// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {ChatList} from "../src/ChatList.sol";

contract ChatListScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        ChatList instance = new ChatList();
        console.log("Contract deployed to %s", address(instance));
        vm.stopBroadcast();
    }
}
