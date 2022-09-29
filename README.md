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
