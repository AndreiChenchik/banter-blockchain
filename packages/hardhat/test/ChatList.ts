import { expect } from "chai";
import { ethers } from "hardhat";
import { ChatList, Chat } from "../typechain-types";

describe("ChatList", function () {
  let chatList: ChatList;
  let user1: any;
  let user2: any;
  let user3: any;
  let zeroAddress = ethers.ZeroAddress;

  before(async () => {
    const [userA, userB, userC] = await ethers.getSigners();
    user1 = userA;
    user2 = userB;
    user3 = userC;

    const chatListFactory = await ethers.getContractFactory("ChatList");
    chatList = (await chatListFactory.deploy()) as ChatList;
    await chatList.waitForDeployment();
  });

  describe("Creating Chats", function () {
    it("Should create a chat between two users", async function () {
      await expect(chatList.connect(user1).createChat(user2.address))
        .to.emit(chatList, "ChatCreated")
        .withArgs(
          user1.address,
          user2.address,
          // Not validating the exact chat contract address here
          // will check it in the next tests
          ethers.isAddress,
          await ethers.provider.getBlock("latest").then(b => b!.timestamp + 1),
        );
    });

    it("Should revert when trying to chat with zero address", async function () {
      await expect(chatList.connect(user1).createChat(zeroAddress)).to.be.revertedWithCustomError(
        chatList,
        "InvalidRecipientAddress",
      );
    });

    it("Should revert when trying to chat with yourself", async function () {
      await expect(chatList.connect(user1).createChat(user1.address)).to.be.revertedWithCustomError(
        chatList,
        "CannotChatWithYourself",
      );
    });

    it("Should allow retrieving user chats", async function () {
      // Create another chat between user1 and user3
      await chatList.connect(user1).createChat(user3.address);

      // Get all chats for user1
      const user1Chats = await chatList.connect(user1).getUserChats();

      // Should have 2 chats (with user2 and user3)
      expect(user1Chats.length).to.equal(2);

      // Verify chat details
      expect(user1Chats[0].author).to.equal(user1.address);
      expect(user1Chats[0].recipient).to.equal(user2.address);
      expect(user1Chats[1].author).to.equal(user1.address);
      expect(user1Chats[1].recipient).to.equal(user3.address);
    });

    it("Should allow getting a specific chat by address", async function () {
      // Create a new chat and capture its address
      const tx = await chatList.connect(user2).createChat(user3.address);
      const receipt = await tx.wait();

      // Extract chat address from event
      const event = receipt?.logs[0] as any;
      const chatAddress = event.args[2]; // Chat contract address is the third argument

      // Get chat by address
      const chat = await chatList.connect(user2).getChat(chatAddress);

      expect(chat.chatContract).to.equal(chatAddress);
      expect(chat.author).to.equal(user2.address);
      expect(chat.recipient).to.equal(user3.address);
    });

    it("Should revert when getting non-existent chat", async function () {
      const nonExistentChatAddress = "0x1111111111111111111111111111111111111111";

      await expect(chatList.connect(user1).getChat(nonExistentChatAddress)).to.be.revertedWithCustomError(
        chatList,
        "ChatDoesNotExist",
      );
    });

    it("Should create a proper Chat contract that allows messaging", async function () {
      // Create a new chat
      const tx = await chatList.connect(user1).createChat(user2.address);
      const receipt = await tx.wait();

      // Extract chat address from event
      const event = receipt?.logs[0] as any;
      const chatAddress = event.args[2]; // Chat contract address is the third argument

      // Connect to the created Chat contract
      const chatFactory = await ethers.getContractFactory("Chat");
      const chatContract = chatFactory.attach(chatAddress) as Chat;

      // Test sending messages
      const message = "Hello from the test!";

      await expect(chatContract.connect(user1).sendMessage(message))
        .to.emit(chatContract, "MessageSent")
        .withArgs(user1.address, message, await ethers.provider.getBlock("latest").then(b => b!.timestamp + 1));

      // Test recipient can respond
      const response = "Hello back from the test!";

      await expect(chatContract.connect(user2).sendMessage(response))
        .to.emit(chatContract, "MessageSent")
        .withArgs(user2.address, response, await ethers.provider.getBlock("latest").then(b => b!.timestamp + 1));
    });
  });
});
