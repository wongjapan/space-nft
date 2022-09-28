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
  uint256 public feeShips = 500000000000000000000;
  address public receiveFee = payable(0x9c39E1d30D2Fd9b13Ca37BB4117E4C6a58541c66);

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

  event summonhero(address Owner, uint256 tokenId, string nameShip, string shipClass, string tier, string typeIssue);
  event openpackage(address Owner, uint256 tokenId, string nameShip, string shipClass, string tier);
  event RequestShip(uint256 tokenId, address Owner, uint256 numberShip, string tier, string typeIssue);

  struct Ship {
    string shipName;
    string shipClass;
    string shipLevel;
  }
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
    string[] memory shipName,
    string[] memory shipClass,
    string[] memory shipLevel
  ) public {
    require(hasRole(DEFAULT_ADMIN_ROLE, address(msg.sender)), "Caller is not a owner");
    for (uint256 i = 0; i < shipName.length; i++) {
      ships[id[i]] = Ship(shipName[i], shipClass[i], shipLevel[i]);
    }
  }

  function editShip(
    uint256 _id,
    string memory name,
    string memory shipClass,
    string memory shipLevel
  ) public {
    require(hasRole(DEFAULT_ADMIN_ROLE, address(msg.sender)), "Caller is not a owner");
    ships[_id].name = name;
    ships[_id].shipClass = shipClass;
    ships[_id].shipLevel = shipLevel;
  }

  function changeFee(uint256 _fee) public {
    require(hasRole(DEFAULT_ADMIN_ROLE, address(msg.sender)), "Caller is not a owner");
    require(_fee > 0, "need fee > 0");
    feeShip = _fee;
  }

  function changeFees(uint256 _fee) public {
    require(hasRole(DEFAULT_ADMIN_ROLE, address(msg.sender)), "Caller is not a owner");
    require(_fee > 0, "need fee > 0");
    feeShips = _fee;
  }

  function requestCard(
    uint256 _tokenId,
    uint256 _numberHero,
    string memory _level
  ) public {
    f4hToken.safeTransferFrom(address(msg.sender), address(receiveFee), feeCard);
    require(queryLevelName(_level) == 1, "Tier not found");
    require(
      queryNumberLevel(_level) == 0 || queryNumberLevel(_level) == 1 || queryNumberLevel(_level) == 3,
      "tier is not allowed to issue"
    );
    require(keccak256(bytes(ships[_numberHero].name)) != keccak256(bytes(stringNull)), "Ship not found");
    emit RequestShip(_tokenId, msg.sender, _numberHero, _level, "Card");
  }

  function requestSummon(
    uint256 _tokenId,
    uint256 _numberHero,
    string memory _level
  ) public {
    f4hToken.safeTransferFrom(address(msg.sender), address(receiveFee), feeShip);
    require(queryLevelName(_level) == 1, "Tier not found");
    require(
      queryNumberLevel(_level) == 0 || queryNumberLevel(_level) == 1 || queryNumberLevel(_level) == 3,
      "tier is not allowed to issue"
    );
    require(keccak256(bytes(ships[_numberHero].name)) != keccak256(bytes(stringNull)), "Ship not found");
    emit RequestShip(_tokenId, msg.sender, _numberHero, _level, "Summon");
  }

  function openPackage(
    address[] memory _owner,
    uint256[] memory _tokenId,
    uint256[] memory _numberHero,
    string[] memory _level
  ) public {
    require(hasRole(CREATOR_ADMIN_SERVER, address(msg.sender)), "Caller is not a admin");
    require(
      _owner.length == _numberHero.length && _tokenId.length == _numberHero.length && _tokenId.length == _level.length,
      "Input not true"
    );
    for (uint256 i = 0; i < _tokenId.length; i++) {
      require(queryLevelName(_level[i]) == 1, "Tier not found");
      require(queryNumberLevel(_level[i]) == 1, "Tier is not allowed to issue");
      require(heroOpenPack[_numberHero[i]], "Number Hero is not allowed to issue");
      require(keccak256(bytes(ships[_numberHero[i]].name)) != keccak256(bytes(stringNull)), "Ship not found");
      shipNFT.safeMint(address(_owner[i]), _tokenId[i]);
      shipNFT.addShipNumber(
        _tokenId[i],
        _numberHero[i],
        ships[_numberHero[i]].name,
        ships[_numberHero[i]].shipClass,
        ships[_numberHero[i]].shipLevel,
        _level[i],
        _level[i]
      );
      emit openpackage(_owner[i], _tokenId[i], ships[_numberHero[i]].name, ships[_numberHero[i]].shipClass, _level[i]);
    }
  }

  function summon(
    address[] memory _owner,
    uint256[] memory _tokenId,
    uint256[] memory _numberHero,
    string[] memory _level,
    string[] memory _type
  ) public {
    require(hasRole(CREATOR_ADMIN_SERVER, address(msg.sender)), "Caller is not a admin");
    require(
      _owner.length == _numberHero.length &&
        _tokenId.length == _numberHero.length &&
        _tokenId.length == _level.length &&
        _tokenId.length == _type.length,
      "Input not true"
    );
    for (uint256 i = 0; i < _tokenId.length; i++) {
      require(queryLevelName(_level[i]) == 1, "Tier not found");
      require(
        queryNumberLevel(_level[i]) == 0 || queryNumberLevel(_level[i]) == 1 || queryNumberLevel(_level[i]) == 3,
        "tier is not allowed to issue"
      );
      require(keccak256(bytes(ships[_numberHero[i]].name)) != keccak256(bytes(stringNull)), "Ship not found");
      shipNFT.safeMint(address(_owner[i]), _tokenId[i]);
      shipNFT.addShipNumber(
        _tokenId[i],
        _numberHero[i],
        ships[_numberHero[i]].name,
        ships[_numberHero[i]].shipClass,
        ships[_numberHero[i]].shipLevel,
        _level[i],
        _level[i]
      );
      emit summonhero(
        _owner[i],
        _tokenId[i],
        ships[_numberHero[i]].name,
        ships[_numberHero[i]].shipClass,
        _level[i],
        _type[i]
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
