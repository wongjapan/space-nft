const hre = require("hardhat");
const {ethers} = require("hardhat");

async function main() {
  // We get the contract to deploy
  const GameItem = await hre.ethers.getContractFactory("GameItem");
  const gameItem = await GameItem.deploy();
  const r1 = await gameItem.deployed();
  console.log(r1.deployTransaction.hash);

  console.log("GameItem deployed to:", gameItem.address);

  try {
    await hre.run("verify", {
      address: gameItem.address,
    });
  } catch (error) {
    console.error(error);
    console.log(`Smart contract at address ${gameItem.address} is already verified`);
  }
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
