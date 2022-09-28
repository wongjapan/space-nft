// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./abstract/AccessControl.sol";
import "./library/SafeMath.sol";
import "./library/SafeBEP20.sol";
import "./interface/IShip.sol";

contract ShipIssuer is AccessControl {
  using SafeMath for uint256;
  using SafeBEP20 for IBEP20;

  IShip public shipNFT;
  IBEP20 public f4hToken;

  bytes32 public constant CREATOR_ADMIN_SERVER = keccak256("CREATOR_ADMIN_SERVER");
  string public stringNull = "";
  uint256 public feeShip = 50000000000000000000;
  address public receiveFee = payable(0x3631f25ea6f2368D3A927685acD2C5c43CE05049);

  constructor(
    address minter,
    address _ship,
    address _f4hToken
  ) {
    _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
    _setupRole(CREATOR_ADMIN_SERVER, minter);
    shipNFT = IShip(_ship);
    f4hToken = IBEP20(_f4hToken);
  }

  event RequestShip(uint256 tokenId, address owner, uint256 shipNumber);
  event DeliverShip(
    address owner,
    uint256 tokenId,
    uint256 shipNumber,
    string shipName,
    string shipClass,
    string shipLevel,
    uint256 shipSpeed,
    uint256 shipWeight,
    uint256 shipTurningAngle,
    uint256 shipMissileSpeed,
    string shipLaserType,
    uint256 shipLaserSlot
  );

  /**
   * default state of ship
   */
  struct Ship {
    string shipName;
    string shipClass;
    string shipLevel;
    uint256 shipSpeed;
    uint256 shipWeight;
    uint256 shipTurningAngle;
    uint256 shipMissileSpeed;
    string shipLaserType;
    uint256 shipLaserSlot;
  }

  /**
   * level name
   */
  struct LevelName {
    string levelName;
  }
  mapping(uint256 => Ship) public ships; //  tokenId=> Ship Information
  LevelName[] public levelName; // level information

  function changeReceiveFee(address _receive) public {
    require(hasRole(DEFAULT_ADMIN_ROLE, address(msg.sender)), "Caller is not a owner");
    require(_receive != address(0), "cant addr zero");
    receiveFee = payable(_receive);
  }

  function getLevelName() public view returns (LevelName[] memory) {
    return levelName;
  }

  function addLevelName(string[] memory _levelName) public {
    require(hasRole(DEFAULT_ADMIN_ROLE, address(msg.sender)), "Caller is not a owner");
    for (uint256 i = 0; i < _levelName.length; i++) {
      levelName.push(LevelName(_levelName[i]));
    }
  }

  function editLevelName(uint256 _id, string memory _levelName) public {
    require(hasRole(DEFAULT_ADMIN_ROLE, address(msg.sender)), "Caller is not a owner");
    levelName[_id].levelName = _levelName;
  }

  function getShip(uint256 _id) public view returns (Ship memory) {
    return ships[_id];
  }

  function addShip(
    uint256[] memory id,
    string[] memory _shipName,
    string[] memory _shipClass,
    string[] memory _shipLevel,
    uint256[] memory _shipSpeed,
    uint256[] memory _shipWeight,
    uint256[] memory _shipTurningAngle,
    uint256[] memory _shipMissileSpeed,
    string[] memory _shipLaserType,
    uint256[] memory _shipLaserSlot
  ) public {
    require(hasRole(DEFAULT_ADMIN_ROLE, address(msg.sender)), "Caller is not a owner");
    for (uint256 i = 0; i < _shipName.length; i++) {
      ships[id[i]] = Ship(
        _shipName[i],
        _shipClass[i],
        _shipLevel[i],
        _shipSpeed[i],
        _shipWeight[i],
        _shipTurningAngle[i],
        _shipMissileSpeed[i],
        _shipLaserType[i],
        _shipLaserSlot[i]
      );
    }
  }

  function editShip(
    uint256 _id,
    string memory shipName,
    string memory _shipClass,
    string memory _shipLevel,
    uint256 _shipSpeed,
    uint256 _shipWeight,
    uint256 _shipTurningAngle,
    uint256 _shipMissileSpeed,
    string memory _shipLaserType,
    uint256 _shipLaserSlot
  ) public {
    require(hasRole(DEFAULT_ADMIN_ROLE, address(msg.sender)), "Caller is not a owner");
    ships[_id].shipName = shipName;
    ships[_id].shipClass = _shipClass;
    ships[_id].shipLevel = _shipLevel;
    ships[_id].shipSpeed = _shipSpeed;
    ships[_id].shipWeight = _shipWeight;
    ships[_id].shipTurningAngle = _shipTurningAngle;
    ships[_id].shipMissileSpeed = _shipMissileSpeed;
    ships[_id].shipLaserType = _shipLaserType;
    ships[_id].shipLaserSlot = _shipLaserSlot;
  }

  function changeFee(uint256 _fee) public {
    require(hasRole(DEFAULT_ADMIN_ROLE, address(msg.sender)), "Caller is not a owner");
    require(_fee > 0, "need fee > 0");
    feeShip = _fee;
  }

  function requestShip(uint256 _tokenId, uint256 _shipNumber) public {
    f4hToken.safeTransferFrom(address(msg.sender), address(receiveFee), feeShip);
    emit RequestShip(_tokenId, msg.sender, _shipNumber);
  }

  function deliverShip(
    address[] memory _owner,
    uint256[] memory _tokenId,
    uint256[] memory _shipNumber
  ) public {
    require(hasRole(CREATOR_ADMIN_SERVER, address(msg.sender)), "Caller is not a admin");
    require(_owner.length == _shipNumber.length && _tokenId.length == _shipNumber.length, "Input not true");
    for (uint256 i = 0; i < _tokenId.length; i++) {
      require(keccak256(bytes(ships[_shipNumber[i]].shipName)) != keccak256(bytes(stringNull)), "Ship not found");
      string memory level = levelName[0].levelName;
      shipNFT.safeMint(address(_owner[i]), _tokenId[i]);
      uint256 shipNumberTemp = _shipNumber[i];
      shipNFT.addShip(
        _tokenId[i],
        shipNumberTemp,
        ships[shipNumberTemp].shipName,
        ships[shipNumberTemp].shipClass,
        level,
        ships[shipNumberTemp].shipSpeed,
        ships[shipNumberTemp].shipWeight,
        ships[shipNumberTemp].shipTurningAngle,
        ships[shipNumberTemp].shipMissileSpeed,
        ships[shipNumberTemp].shipLaserType,
        ships[shipNumberTemp].shipLaserSlot
      );
      emit DeliverShip(
        _owner[i],
        _tokenId[i],
        shipNumberTemp,
        ships[shipNumberTemp].shipName,
        ships[shipNumberTemp].shipClass,
        level,
        ships[shipNumberTemp].shipSpeed,
        ships[shipNumberTemp].shipWeight,
        ships[shipNumberTemp].shipTurningAngle,
        ships[shipNumberTemp].shipMissileSpeed,
        ships[shipNumberTemp].shipLaserType,
        ships[shipNumberTemp].shipLaserSlot
      );
    }
  }

  function queryLevelName(string memory _level) public view returns (uint256) {
    uint256 result = 0;
    for (uint256 i = 0; i < levelName.length; i++) {
      if (keccak256(bytes(levelName[i].levelName)) == keccak256(bytes(_level))) {
        result = 1;
      }
    }
    return result;
  }

  function queryNumberLevel(string memory _level) public view returns (uint256) {
    uint256 result = 100;
    for (uint256 i = 0; i < levelName.length; i++) {
      if (keccak256(bytes(levelName[i].levelName)) == keccak256(bytes(_level))) {
        result = i;
      }
    }
    return result;
  }
}
