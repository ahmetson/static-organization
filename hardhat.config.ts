import dotenv from "dotenv";
import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import 'hardhat-deploy';
import 'hardhat-abi-exporter';

dotenv.config();

const config: HardhatUserConfig = {
  solidity: "0.8.19",
  abiExporter: {
    runOnCompile: true,
    pretty: false,
    clear: true,
    flat: true,
  },
  namedAccounts: {
    deployer: 0,
  },
  networks: {
    sepolia: {
      url: process.env.SEPOLIA_URL!,
      accounts: [process.env.SEPOLIA_ACCOUNT!],
    }
  }
};

export default config;
