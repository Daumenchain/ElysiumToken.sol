const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  const initialOwner = deployer.address;
  const initialDevWallet = "0xDeineDevWalletAdresseHierEinfuegen"; // Trage hier deine Dev-Adresse ein

  const SimpsonsToken = await hre.ethers.getContractFactory("SimpsonsToken");
  const simpsonsToken = await SimpsonsToken.deploy(initialOwner, initialDevWallet);

  await simpsonsToken.waitForDeployment();

  console.log(`SimpsonsToken deployed to: ${await simpsonsToken.getAddress()}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
