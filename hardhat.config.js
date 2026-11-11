import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from "dotenv";

dotenv.config();

const PRIVATE_KEY = process.env.PRIVATE_KEY || "";

/** @type import('hardhat/config').HardhatUserConfig */
export default {
  solidity: "0.8.20",
  networks: {
    elysium: {
      url: "https://rpc.elysiumchain.tech",
      chainId: 1339,
      accounts: PRIVATE_KEY ? [PRIVATE_KEY] : [],
    },
  },
};

