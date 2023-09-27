// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MTZToken is ERC20, Ownable {
    constructor() ERC20("MultichainZ", "MTZ") {
        uint initialSupply = 1000000 * 10 ** 18;
        _mint(msg.sender, initialSupply);
    }
    function mint(address to, uint amount) external onlyOwner {
        _mint(to, amount);
    }

    function burn(address from, uint amount) external onlyOwner {
        _burn(from, amount);
    }

}
