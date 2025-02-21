// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {BanterCoin} from "src/BanterCoin.sol";

contract BanterCoinScript is Script {
  function setUp() public {}

  function run() public {
    // TODO: Set addresses for the variables below, then uncomment the following section:
    /*
    vm.startBroadcast();
    address recipient = <Set recipient address here>;
    BanterCoin instance = new BanterCoin(recipient);
    console.log("Contract deployed to %s", address(instance));
    vm.stopBroadcast();
    */
  }
}
