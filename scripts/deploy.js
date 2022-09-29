const hre = require("hardhat");
const {ethers} = require("hardhat");

async function main() {
  // We get the contract to deploy
  // change this to your address
  const deployer = "0x3631f25ea6f2368D3A927685acD2C5c43CE05049";

  const MockF4H = await hre.ethers.getContractFactory("MockF4H");
  const mockF4H = await MockF4H.deploy();
  console.log("MockF4H deployed to:", mockF4H.address);

  const Ship = await hre.ethers.getContractFactory("Ship");
  const ship = await Ship.deploy();
  console.log("Ship deployed to:", ship.address);

  const ShipIssuer = await hre.ethers.getContractFactory("ShipIssuer");
  const shipIssuer = await ShipIssuer.deploy(deployer, ship.address, mockF4H.address);
  console.log("ShipIssuer deployed to:", shipIssuer.address);

  try {
    await hre.run("verify", {
      address: mockF4H.address,
      constructorArgsParams: ["Fight 4 Hope", "F4H"],
    });
  } catch (error) {
    console.error(error);
    console.log(`Smart contract at address ${mockF4H.address} is already verified`);
  }

  try {
    await hre.run("verify", {
      address: ship.address,
    });
  } catch (error) {
    console.error(error);
    console.log(`Smart contract at address ${ship.address} is already verified`);
  }
  try {
    await hre.run("verify", {
      address: shipIssuer.address,
      constructorArgsParams: [deployer, ship.address, mockF4H.address],
    });
  } catch (error) {
    console.error(error);
    console.log(`Smart contract at address ${ship.address} is already verified`);
  }
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
