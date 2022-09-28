// contracts/MockF4H.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockF4H is ERC20 {
  constructor() ERC20("Fight 4 Hope", "F4H") {
    _mint(msg.sender, 10**24);
  }
}
