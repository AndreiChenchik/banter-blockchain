import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
import { Contract } from "ethers";

/**
 * Deploys the ChatList contract
 *
 * @param hre HardhatRuntimeEnvironment object.
 */
const deployChatList: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = hre.deployments;

  // ChatList has no constructor arguments
  const deployResult = await deploy("ChatList", {
    from: deployer,
    args: [],
    log: true,
    autoMine: true,
  });

  // Get the deployed contract
  const chatList = await hre.ethers.getContract<Contract>("ChatList", deployer);
  console.log("💬 ChatList deployed at:", await chatList.getAddress());

  // Verify contract if not on a local network
  const networkName = hre.network.name;
  if (networkName !== "localhost" && networkName !== "hardhat") {
    console.log("Waiting for 6 confirmations before verification...");
    await new Promise(resolve => setTimeout(resolve, 60000)); // Wait 60 seconds for good measure

    try {
      await hre.run("verify:verify", {
        address: deployResult.address,
        constructorArguments: [],
        contract: "contracts/ChatList.sol:ChatList",
      });
      console.log("✅ ChatList contract verified");
    } catch (error: any) {
      if (error.message.includes("already verified")) {
        console.log("Contract already verified!");
      } else {
        console.error("Error verifying contract:", error);
      }
    }
  }
};

export default deployChatList;

// Tags are useful if you have multiple deploy files and only want to run one of them.
// e.g. yarn deploy --tags ChatList
deployChatList.tags = ["ChatList"];
