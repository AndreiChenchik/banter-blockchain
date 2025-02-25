import { expect } from "chai";
import { ethers } from "hardhat";
import { Chat } from "../typechain-types";

describe("Chat", function () {
  let chat: Chat;
  let author: any;
  let recipient: any;
  let otherUser: any;

  before(async () => {
    const [userA, userB, userC] = await ethers.getSigners();
    author = userA;
    recipient = userB;
    otherUser = userC;

    const chatFactory = await ethers.getContractFactory("Chat");
    chat = (await chatFactory.deploy(author.address, recipient.address)) as Chat;
    await chat.waitForDeployment();
  });

  describe("Deployment", function () {
    it("Should set the correct author and recipient", async function () {
      expect(await chat.author()).to.equal(author.address);
      expect(await chat.recipient()).to.equal(recipient.address);
    });
  });

  describe("Messaging", function () {
    it("Should allow author to send a message", async function () {
      const message = "Hello, this is a test message!";

      await expect(chat.connect(author).sendMessage(message))
        .to.emit(chat, "MessageSent")
        .withArgs(author.address, message, await ethers.provider.getBlock("latest").then(b => b!.timestamp + 1));
    });

    it("Should allow recipient to send a message", async function () {
      const message = "Hello back to you!";

      await expect(chat.connect(recipient).sendMessage(message))
        .to.emit(chat, "MessageSent")
        .withArgs(recipient.address, message, await ethers.provider.getBlock("latest").then(b => b!.timestamp + 1));
    });

    it("Should revert if a non-participant tries to send a message", async function () {
      const message = "I'm not part of this conversation";

      await expect(chat.connect(otherUser).sendMessage(message)).to.be.revertedWithCustomError(
        chat,
        "OnlyChatParticipantsCanSendMessages",
      );
    });

    it("Should revert if message is empty", async function () {
      const emptyMessage = "";

      await expect(chat.connect(author).sendMessage(emptyMessage)).to.be.revertedWithCustomError(
        chat,
        "MessageCannotBeEmpty",
      );
    });
  });
});
