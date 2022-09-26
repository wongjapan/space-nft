// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface ISpaceShipDesign {
  function getTokenLimit() external view returns (uint256);

  function getMintCost() external view returns (uint256);

  function getMaxLevel() external view returns (uint256);

  function getUpgradeCost(uint256 rarity, uint256 level) external view returns (uint256);

  function createRandomToken(
    uint256 seed,
    uint256 id,
    uint256 rarity
  ) external view returns (uint256 nextSeed, uint256 encodedDetails);
}
