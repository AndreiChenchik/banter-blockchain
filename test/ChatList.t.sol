// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console2} from "forge-std/Test.sol";
import {ChatList} from "../src/ChatList.sol";

contract ChatListTest is Test {
    ChatList public chatList;
    address public alice;
    address public bob;
    address public charlie;

    function setUp() public {
        chatList = new ChatList();
        alice = makeAddr("alice");
        bob = makeAddr("bob");
        charlie = makeAddr("charlie");
    }

    function test_CreateChat() public {
        vm.startPrank(alice);
        bytes32 chatId = chatList.createChat(bob);

        ChatList.Chat memory chat = chatList.getChat(chatId);
        assertEq(chat.author, alice);
        assertEq(chat.recipient, bob);
        assertTrue(chat.exists);
    }

    function test_GetUserChats() public {
        vm.startPrank(alice);
        bytes32 chatId1 = chatList.createChat(bob);
        bytes32 chatId2 = chatList.createChat(charlie);
        vm.stopPrank();

        vm.startPrank(bob);
        bytes32 chatId3 = chatList.createChat(charlie);
        vm.stopPrank();

        // Test Alice's chats
        ChatList.Chat[] memory aliceChats = chatList.getUserChats(alice);
        assertEq(aliceChats.length, 2);
        assertEq(aliceChats[0].author, alice);
        assertEq(aliceChats[0].recipient, bob);
        assertEq(aliceChats[1].author, alice);
        assertEq(aliceChats[1].recipient, charlie);

        // Test Bob's chats
        ChatList.Chat[] memory bobChats = chatList.getUserChats(bob);
        assertEq(bobChats.length, 2);
        assertTrue(bobChats[0].author == alice && bobChats[0].recipient == bob);
        assertTrue(
            bobChats[1].author == bob && bobChats[1].recipient == charlie
        );
    }

    function testFail_CreateChatWithSelf() public {
        vm.prank(alice);
        chatList.createChat(alice);
    }

    function testFail_CreateChatWithZeroAddress() public {
        vm.prank(alice);
        chatList.createChat(address(0));
    }

    function testFail_GetNonExistentChat() public {
        bytes32 nonExistentChatId = bytes32(0);
        chatList.getChat(nonExistentChatId);
    }

    function test_ChatCreatedEvent() public {
        vm.startPrank(alice);

        vm.expectEmit(true, true, true, true);
        bytes32 expectedChatId = keccak256(
            abi.encodePacked(alice, bob, block.timestamp)
        );
        emit ChatList.ChatCreated(expectedChatId, alice, bob, block.timestamp);

        chatList.createChat(bob);
    }
}
