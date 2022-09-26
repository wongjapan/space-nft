// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

library SpaceShipDetails {
  uint256 public constant ALL_RARITY = 0;

  struct Details {
    uint256 id;
    uint256 index;
    uint256 rarity;
    uint256 level;
    uint256 speed;
    uint256 weight;
    uint256 turningAgle;
    uint256 bodyType;
    uint256 missileType;
    uint256 laserType;
    uint256[] abilities;
  }

  function encode(Details memory details) internal pure returns (uint256) {
    uint256 value;
    value |= details.id;
    value |= details.index << 30;
    value |= details.rarity << 40;
    value |= details.level << 45;
    value |= details.speed << 50;
    value |= details.weight << 55;
    value |= details.turningAgle << 60;
    value |= details.bodyType << 65;
    value |= details.missileType << 70;
    value |= details.laserType << 75;
    value |= details.abilities.length << 80;
    for (uint256 i = 0; i < details.abilities.length; ++i) {
      value |= details.abilities[i] << (85 + i * 5);
    }
    return value;
  }

  function decode(uint256 details) internal pure returns (Details memory result) {
    result.id = decodeId(details);
    result.index = decodeIndex(details);
    result.rarity = decodeRarity(details);
    result.level = decodeLevel(details);
    result.speed = (details >> 50) & 31;
    result.weight = (details >> 55) & 31;
    result.turningAgle = (details >> 60) & 31;
    result.bodyType = (details >> 65) & 31;
    result.missileType = (details >> 70) & 31;
    result.laserType = (details >> 75) & 31;
    uint256 ability = (details >> 80) & 31;
    result.abilities = new uint256[](ability);
    for (uint256 i = 0; i < ability; ++i) {
      result.abilities[i] = (details >> (85 + i * 5)) & 31;
    }
  }

  function decodeId(uint256 details) internal pure returns (uint256) {
    return details & ((1 << 30) - 1);
  }

  function decodeIndex(uint256 details) internal pure returns (uint256) {
    return (details >> 30) & ((1 << 10) - 1);
  }

  function decodeRarity(uint256 details) internal pure returns (uint256) {
    return (details >> 40) & 31;
  }

  function decodeLevel(uint256 details) internal pure returns (uint256) {
    return (details >> 45) & 31;
  }

  function increaseLevel(uint256 details) internal pure returns (uint256) {
    uint256 level = decodeLevel(details);
    details &= ~(uint256(31) << 45);
    details |= (level + 1) << 45;
    return details;
  }

  function setIndex(uint256 details, uint256 index) internal pure returns (uint256) {
    details &= ~(uint256(1023) << 30);
    details |= index << 30;
    return details;
  }
}
