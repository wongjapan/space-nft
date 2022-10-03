const hre = require("hardhat");
const {ethers} = require("hardhat");

async function main() {
  try {
    await hre.run("verify", {
      address: "0x87b714b0d3390a275d2d6d421b25331cb2e830b2",
      constructorArgsParams: ["Fight 4 Hope", "F4H"],
      contract: "contracts/MockF4H.sol:MockF4H",
    });
  } catch (error) {
    console.error(error);
    console.log(`Smart contract at address 0x87b714b0d3390a275d2d6d421b25331cb2e830b2 is already verified`);
  }
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
