import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
import { Contract } from "ethers";

/**
 * Deploys the BanterCoin contract
 *
 * @param hre HardhatRuntimeEnvironment object.
 */
const deployBanterCoin: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = hre.deployments;

  // Deploy BanterCoin with the deployer as the recipient of initial tokens
  const deployResult = await deploy("BanterCoin", {
    from: deployer,
    args: [deployer], // Pass deployer as recipient of initial token supply
    log: true,
    autoMine: true,
  });

  // Get the deployed contract
  const banterCoin = await hre.ethers.getContract<Contract>("BanterCoin", deployer);
  console.log("🪙 BanterCoin deployed at:", await banterCoin.getAddress());
  console.log("📊 Total supply:", (await banterCoin.totalSupply()).toString());

  // Verify contract if not on a local network
  const networkName = hre.network.name;
  if (networkName !== "localhost" && networkName !== "hardhat") {
    console.log("Waiting for 6 confirmations before verification...");
    await new Promise(resolve => setTimeout(resolve, 60000)); // Wait 60 seconds for good measure

    try {
      await hre.run("verify:verify", {
        address: deployResult.address,
        constructorArguments: [deployer],
        contract: "contracts/BanterCoin.sol:BanterCoin",
      });
      console.log("✅ BanterCoin contract verified");
    } catch (error: any) {
      if (error.message.includes("already verified")) {
        console.log("Contract already verified!");
      } else {
        console.error("Error verifying contract:", error);
      }
    }
  }
};

export default deployBanterCoin;

// Tags are useful if you have multiple deploy files and only want to run one of them.
// e.g. yarn deploy --tags BanterCoin
deployBanterCoin.tags = ["BanterCoin"];
