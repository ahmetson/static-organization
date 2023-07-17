import { ethers } from "hardhat";

async function main() {
  const staticOrganization = await ethers.deployContract("StaticOrganization", [], {});

  await staticOrganization.waitForDeployment();

  console.log(
    `StaticOrganization deployed to ${staticOrganization.target}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
