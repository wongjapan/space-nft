// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC721.sol";

interface IShip is IERC721 {
  struct ShipInfo {
    uint256 shipNumber; // id of ship
    string shipName; // ship given name
    string shipClass; // body type : light, medium, heavy, destroyer
    string shipLevel; // scout, Scavenger, Squatter, Reclaimer, Colonist, Salvager of Hope
    uint256 shipSpeed;
    uint256 shipWeight;
    uint256 shipTurningAngle;
    uint256 shipMissileSpeed;
    string shipLaserType;
    uint256 shipLaserSlot;
  }

  function getShip(uint256 _tokenId) external view returns (ShipInfo memory);

  function safeMint(address _to, uint256 _tokenId) external;

  function burn(address _from, uint256 _tokenId) external;

  function addShip(
    uint256 _tokenId,
    uint256 _shipNumber,
    string memory _shipName,
    string memory _shipClass,
    string memory _shipLevel,
    uint256 _shipSpeed,
    uint256 _shipWeight,
    uint256 _shipTurningAngle,
    uint256 _shipMissileSpeed,
    string memory _shipLaserType,
    uint256 _shipLaserSlot
  ) external;

  function editLevel(uint256 tokenId, string memory _shipLevel) external;

  function editLaserType(uint256 tokenId, string memory _shipLaserType) external;

  function editSpeed(uint256 tokenId, uint256 _shipSpeed) external;

  function editWeight(uint256 tokenId, uint256 _shipWeight) external;

  function editTurningAngle(uint256 tokenId, uint256 _shipTurningAngle) external;

  function editMissileSpeed(uint256 tokenId, uint256 _shipMissileSpeed) external;

  function editLaserSlot(uint256 tokenId, uint256 _shipLaserSlot) external;

  function deleteShip(uint256 tokenId) external;
}
