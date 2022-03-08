// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract AstroXP_Governance is ERC20 {
    constructor(uint256 initialSupply) ERC20("AstroXP", "AXP") {
         _mint(msg.sender, initialSupply * (10 ** uint256(decimals()))); 
    }
}