// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract Assets is ERC721, ERC721Enumerable, Pausable, AccessControl {
  bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
  bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
  bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");
  string public baseURI = "";

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
  mapping(uint256 => ShipInfo) public shipInfo;

  function getShip(uint256 _tokenId) external view returns (ShipInfo memory) {
    return shipInfo[_tokenId];
  }

  constructor() ERC721("F4H Ship", "F4HS") {
    _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    _setupRole(PAUSER_ROLE, msg.sender);
    _setupRole(MINTER_ROLE, msg.sender);
  }

  function _baseURI() internal view virtual override returns (string memory) {
    return baseURI;
  }

  function setBaseURI(string memory _baseUri) public onlyRole(DEFAULT_ADMIN_ROLE) {
    baseURI = _baseUri;
  }

  function pause() public onlyRole(PAUSER_ROLE) {
    _pause();
  }

  function unpause() public onlyRole(PAUSER_ROLE) {
    _unpause();
  }

  function safeMint(address to, uint256 tokenId) public onlyRole(MINTER_ROLE) {
    _safeMint(to, tokenId);
  }

  function burn(address owner, uint256 tokenId) public onlyRole(MINTER_ROLE) {
    require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
    _burn(tokenId);
  }

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
  ) public onlyRole(MINTER_ROLE) {
    shipInfo[_tokenId] = ShipInfo(
      _shipNumber,
      _shipName,
      _shipClass,
      _shipLevel,
      _shipSpeed,
      _shipWeight,
      _shipTurningAngle,
      _shipMissileSpeed,
      _shipLaserType,
      _shipLaserSlot
    );
  }

  function editLevel(uint256 tokenId, string memory _shipLevel) public onlyRole(MINTER_ROLE) {
    shipInfo[tokenId].shipLevel = _shipLevel;
  }

  function editLaserType(uint256 tokenId, string memory _shipLaserType) public onlyRole(MINTER_ROLE) {
    shipInfo[tokenId].shipLaserType = _shipLaserType;
  }

  function editSpeed(uint256 tokenId, uint256 _shipSpeed) public onlyRole(MINTER_ROLE) {
    shipInfo[tokenId].shipSpeed = _shipSpeed;
  }

  function editWeight(uint256 tokenId, uint256 _shipWeight) public onlyRole(MINTER_ROLE) {
    shipInfo[tokenId].shipWeight = _shipWeight;
  }

  function editTurningAngle(uint256 tokenId, uint256 _shipTurningAngle) public onlyRole(MINTER_ROLE) {
    shipInfo[tokenId].shipTurningAngle = _shipTurningAngle;
  }

  function editMissileSpeed(uint256 tokenId, uint256 _shipMissileSpeed) public onlyRole(MINTER_ROLE) {
    shipInfo[tokenId].shipMissileSpeed = _shipMissileSpeed;
  }

  function editLaserSlot(uint256 tokenId, uint256 _shipLaserSlot) public onlyRole(MINTER_ROLE) {
    shipInfo[tokenId].shipLaserSlot = _shipLaserSlot;
  }

  function deleteShip(uint256 tokenId) public onlyRole(MINTER_ROLE) {
    delete shipInfo[tokenId];
  }

  function _beforeTokenTransfer(
    address from,
    address to,
    uint256 tokenId
  ) internal override(ERC721, ERC721Enumerable) whenNotPaused {
    super._beforeTokenTransfer(from, to, tokenId);
  }

  // The following functions are overrides required by Solidity.

  function supportsInterface(bytes4 interfaceId)
    public
    view
    override(ERC721, ERC721Enumerable, AccessControl)
    returns (bool)
  {
    return super.supportsInterface(interfaceId);
  }
}
