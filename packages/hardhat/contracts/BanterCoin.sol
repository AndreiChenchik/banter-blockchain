// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.22;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// @custom:security-contact andrei@chenchik.me
contract BanterCoin is ERC20 {
    constructor(address recipient) ERC20("BanterCoin", "BANT") {
        _mint(recipient, 1000000 * 10 ** decimals());
    }
} 