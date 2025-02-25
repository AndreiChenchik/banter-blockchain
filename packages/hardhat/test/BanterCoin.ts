import { expect } from "chai";
import { ethers } from "hardhat";
import { BanterCoin } from "../typechain-types";

describe("BanterCoin", function () {
  let banterCoin: BanterCoin;
  let recipient: any;

  before(async () => {
    const [deployer, user] = await ethers.getSigners();
    recipient = user;

    const banterCoinFactory = await ethers.getContractFactory("BanterCoin");
    banterCoin = (await banterCoinFactory.deploy(recipient.address)) as BanterCoin;
    await banterCoin.waitForDeployment();
  });

  describe("Deployment", function () {
    it("Should have the correct name and symbol", async function () {
      expect(await banterCoin.name()).to.equal("BanterCoin");
      expect(await banterCoin.symbol()).to.equal("BANT");
    });

    it("Should mint initial supply to recipient", async function () {
      const totalSupply = await banterCoin.totalSupply();
      const recipientBalance = await banterCoin.balanceOf(recipient.address);

      expect(recipientBalance).to.equal(totalSupply);
      // 1 million tokens with 18 decimals
      expect(totalSupply).to.equal(ethers.parseUnits("1000000", 18));
    });
  });
});
