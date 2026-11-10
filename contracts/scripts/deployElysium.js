const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  
  const myWallet = "0xC40f4DC6DAE695CbAC5E6D370768Ca7D8cf5E99a";
  
  console.log(`Deploying Elysium Token mit Wallet: ${myWallet}`);

  const Token = await hre.ethers.getContractFactory("ElysiumToken");
  const token = await Token.deploy(myWallet, myWallet, myWallet);

  await token.waitForDeployment();
  console.log(`Elysium Token erfolgreich deployed unter: ${await token.getAddress()}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
