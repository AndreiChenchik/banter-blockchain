// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console2} from "forge-std/Test.sol";
import {Chat} from "../src/Chat.sol";

contract ChatTest is Test {
    Chat public chat;
    address public author;
    address public recipient;
    address public thirdParty;

    function setUp() public {
        author = makeAddr("author");
        recipient = makeAddr("recipient");
        thirdParty = makeAddr("thirdParty");

        // Deploy the Chat contract for testing
        chat = new Chat(author, recipient);
    }

    function test_ConstructorSetup() public view {
        // Verify contract initialized with correct author and recipient
        assertEq(chat.author(), author);
        assertEq(chat.recipient(), recipient);
    }

    function test_SendMessageAsAuthor() public {
        // Send a message as the chat author
        vm.prank(author);

        // Expect the event to be emitted with correct parameters
        vm.expectEmit(true, false, false, true);
        emit Chat.MessageSent(author, "Hello from author", block.timestamp);

        chat.sendMessage("Hello from author");
    }

    function test_SendMessageAsRecipient() public {
        // Send a message as the chat recipient
        vm.prank(recipient);

        // Expect the event to be emitted with correct parameters
        vm.expectEmit(true, false, false, true);
        emit Chat.MessageSent(recipient, "Hello from recipient", block.timestamp);

        chat.sendMessage("Hello from recipient");
    }

    function test_RevertWhen_SendMessageAsNonParticipant() public {
        // Attempt to send a message as a third party (not author or recipient)
        vm.prank(thirdParty);

        // Should revert
        vm.expectRevert(Chat.OnlyChatParticipantsCanSendMessages.selector);
        chat.sendMessage("Hello from third party");
    }

    function test_RevertWhen_SendEmptyMessage() public {
        // Attempt to send an empty message
        vm.prank(author);

        // Should revert
        vm.expectRevert(Chat.MessageCannotBeEmpty.selector);
        chat.sendMessage("");
    }

    function test_SendLongMessage() public {
        // Create a very long message (simulating a stress test)
        string memory longMessage = "";
        for (uint256 i = 0; i < 100; i++) {
            longMessage = string(abi.encodePacked(longMessage, "This is a long message. "));
        }

        // Send the long message as the author
        vm.prank(author);

        // Should not revert
        chat.sendMessage(longMessage);
    }

    function test_SendMultipleMessages() public {
        // Test sending multiple messages from both participants

        // First message from author
        vm.prank(author);
        chat.sendMessage("Message 1 from author");

        // Message from recipient
        vm.prank(recipient);
        chat.sendMessage("Message 1 from recipient");

        // Second message from author
        vm.prank(author);
        chat.sendMessage("Message 2 from author");

        // Second message from recipient
        vm.prank(recipient);
        chat.sendMessage("Message 2 from recipient");
    }
}
