// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {Test} from "forge-std/Test.sol";
import {BanterCoin} from "src/BanterCoin.sol";

contract BanterCoinTest is Test {
  BanterCoin public instance;

  function setUp() public {
    address recipient = vm.addr(1);
    instance = new BanterCoin(recipient);
  }

  function testName() public view {
    assertEq(instance.name(), "BanterCoin");
  }
}
