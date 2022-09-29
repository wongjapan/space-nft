# F4H Space Ship NFT

## Installation

- Clone repository

  ```sh
  git clone  https://github.com/wongjapan/space-nft.git
  ```

- Install dependency

  ```sh
  cd space-nft
  yarn install
  ```

- Create environments

  ```sh
  cp .env.example .env
  ```

  and then change variable on `.env`

  ```
  ETH_URL =
  ROPSTEN_URL =
  BSCTESTNET_URL =
  BSC_URL =
  PRIVATE_KEY=
  ETHERSCAN_API_KEY=
  BSCSCAN_API_KEY=
  ```

  open file on `script/deploy.js` change at `line 7` to your address

  ```
  const deployer = "0x3631f25ea6f2368D3A927685acD2C5c43CE05049";
  ```

- Deploy

  ```sh
  # first we clean of cache
  npx hardhat clean

  # and then compile the contract
  npx hardhat compile

  # now run deploy contract
  # default using network is BSC TESTNET
  # you can look at hardhat.confg.js
  node ./script/deploy.js
  ```

## Understanding the contract works

- MockF4H.sol

  This contract just mock of Fight 4 Hope contract, if we want to deploy on mainnet, this contract is doesn't need to deploy

- Ship.sol

  This is Ship main contract, all ship owned by client / player is on here

  To mint / upgrade / edit **Ship** we need `ShipIssuer` contract

  there's 3 (Three) roles on this contract :

  - Admin roles
  - Pauser roles
  - Minter roles

  the only **Important** function on this contract is `setBaseURI` because image of ship will be on this `url`

- ShipIssuer.sol

  This is Ship Factory contract, user / client will interact with this contract when mint `Ship`.

  Now ship design template is only about 5 ship, and 3 ship have different color, so wen can call the design is 8 ship

  First of all we need add ship template to this contract, this can be done by using function `addShip`

  after add ship template we need add Level of ship, this can be done by `addLevelName` function

  **Mint ship flow**

  - player request to this contract by call function `requestShip` and pay `fee`
  - server will read event on blockchain
  - server / minter address send ship requested by player, this can be done by using `deliverShip` function
