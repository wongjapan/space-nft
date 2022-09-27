// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./Dependency.sol";

contract F4HIssuer is AccessControl {
  IF4HAssets public shipsAssets;
  bytes32 public constant CREATOR_ADMIN_SERVER = keccak256("CREATOR_ADMIN_SERVER");
  string public stringNull = "";

  constructor(address minter, address _shipsAssets) {
    _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
    _setupRole(CREATOR_ADMIN_SERVER, minter);
    shipsAssets = IF4HAssets(_shipsAssets); // F4H Assets
  }

  event mintship(address Owner, uint256 tokenId, string shipName, string shipType, string shipClass, string shipTier);
  string[] public shipTier; // tier information
  string[] public shipType; // type information

  function addShipTier(string[] memory _shipTier) public {
    require(hasRole(DEFAULT_ADMIN_ROLE, address(msg.sender)), "Caller is not a owner");
    for (uint256 i = 0; i < _shipTier.length; i++) {
      shipTier.push(_shipTier[i]);
    }
  }

  function editShipTier(uint256 _id, string memory _shipTier) public {
    require(hasRole(DEFAULT_ADMIN_ROLE, address(msg.sender)), "Caller is not a owner");
    shipTier[_id] = _shipTier;
  }

  function addShipType(string[] memory _shipType) public {
    require(hasRole(DEFAULT_ADMIN_ROLE, address(msg.sender)), "Caller is not a owner");
    for (uint256 i = 0; i < _shipType.length; i++) {
      shipType.push(_shipType[i]);
    }
  }

  function editShipType(uint256 _id, string memory _shipType) public {
    require(hasRole(DEFAULT_ADMIN_ROLE, address(msg.sender)), "Caller is not a owner");
    shipType[_id] = _shipType;
  }

  function queryNumberTier(string memory _tier) public view returns (uint256) {
    uint256 result = 100;
    for (uint256 i = 0; i < shipTier.length; i++) {
      if (keccak256(bytes(shipTier[i])) == keccak256(bytes(_tier))) {
        result = i;
      }
    }
    return result;
  }

  mapping(uint256 => bool) public idContract;
  mapping(bytes => bool) public usedSignatures;
  mapping(address => bool) public admin;

  function addAdmin(address[] memory _admin) public {
    require(hasRole(DEFAULT_ADMIN_ROLE, address(msg.sender)), "Caller is not a owner");
    for (uint256 i = 0; i < _admin.length; i++) {
      admin[address(_admin[i])] = true;
    }
  }

  function cancelSignature(bytes[] calldata signature, uint256 _idContract) public {
    require(hasRole(CREATOR_ADMIN_SERVER, address(msg.sender)), "Caller is not a admin");
    require(!idContract[_idContract], "ID used");
    for (uint256 i = 0; i < signature.length; i++) {
      usedSignatures[signature[i]] = true;
    }
    idContract[_idContract] = true;
  }

  function mintShip(
    uint256 _shipId,
    string memory _shipName,
    uint256 _shipType,
    string memory _shipClass,
    uint256 _shipTier,
    bytes calldata signature
  ) external {
    require(!usedSignatures[signature], "Mint: signature used.");
    bytes32 criteriaMessageHash = getMessageHash(msg.sender, _shipId, _shipName, _shipType, _shipClass, _shipTier);
    bytes32 ethSignedMessageHash = ECDSA.toEthSignedMessageHash(criteriaMessageHash);
    require(admin[ECDSA.recover(ethSignedMessageHash, signature)], "Mint: invalid seller signature");

    require(_shipType >= 0 && _shipType < shipType.length, "Ship Type not found");
    require(_shipTier >= 0 && _shipTier < shipTier.length, "Ship Tier not found");
    shipsAssets.safeMint(address(msg.sender), _shipId);
    shipsAssets.addShip(_shipId, _shipName, shipType[_shipType], _shipClass, shipTier[_shipTier]);
    emit mintship(msg.sender, _shipId, _shipName, shipType[_shipType], _shipClass, shipTier[_shipTier]);
    usedSignatures[signature] = true;
  }

  function toEthSignedMessageHash(bytes32 _messageHash) public pure returns (bytes32) {
    return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash));
  }

  function getMessageHash(
    address _owner,
    uint256 _shipId,
    string memory _shipName,
    uint256 _shipType,
    string memory _shipClass,
    uint256 _shipTier
  ) public pure returns (bytes32) {
    return keccak256(abi.encodePacked(_owner, _shipId, _shipName, _shipType, _shipClass, _shipTier));
  }
}
