// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract F4HAssets is ERC721, ERC721Enumerable, Pausable, AccessControl {
  bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
  bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
  string public baseURI = "";
  struct ShipsInfo {
    string shipName;
    string shipType;
    string shipClass;
    string shipTier;
  }
  mapping(uint256 => ShipsInfo) public shipInfo;

  function getShip(uint256 _tokenId) external view returns (ShipsInfo memory) {
    return shipInfo[_tokenId];
  }

  constructor() ERC721("F4H Ship Assets", "F4HS") {
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
    uint256 tokenId,
    string memory shipName,
    string memory shipType,
    string memory shipClass,
    string memory shipTier
  ) public onlyRole(MINTER_ROLE) {
    shipInfo[tokenId] = ShipsInfo(shipName, shipType, shipClass, shipTier);
  }

  function editTier(uint256 tokenId, string memory _tier) public onlyRole(MINTER_ROLE) {
    shipInfo[tokenId].shipTier = _tier;
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
