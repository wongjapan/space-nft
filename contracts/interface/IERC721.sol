// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC165.sol";

interface IERC721 is IERC165 {
  event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
  event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
  event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

  function balanceOf(address owner) external view returns (uint256 balance);

  function ownerOf(uint256 tokenId) external view returns (address owner);

  function safeTransferFrom(
    address from,
    address to,
    uint256 tokenId
  ) external;

  function transferFrom(
    address from,
    address to,
    uint256 tokenId
  ) external;

  function approve(address to, uint256 tokenId) external;

  function getApproved(uint256 tokenId) external view returns (address operator);

  function setApprovalForAll(address operator, bool _approved) external;

  function isApprovedForAll(address owner, address operator) external view returns (bool);

  function safeTransferFrom(
    address from,
    address to,
    uint256 tokenId,
    bytes calldata data
  ) external;

  struct HeroesInfo {
    uint256 heroesNumber;
    string name;
    string race;
    string class;
    string tier;
    string tierBasic;
  }

  function getHeroesNumber(uint256 _tokenId) external view returns (HeroesInfo memory);

  function safeMint(address _to, uint256 _tokenId) external;

  function burn(address _from, uint256 _tokenId) external;

  function addHeroesNumber(
    uint256 _tokenId,
    uint256 _heroesNumber,
    string memory name,
    string memory race,
    string memory class,
    string memory tier,
    string memory tierBasic
  ) external;

  function editTier(uint256 tokenId, string memory _tier) external;

  function deleteHeroesNumber(uint256 tokenId) external;
}
