// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Chat} from "./Chat.sol";

/// @title ChatList
/// @notice Contract for managing user chats
contract ChatList {
    struct ChatInfo {
        address chatContract;
        address author;
        address recipient;
        uint256 createdAt;
        bool exists;
    }

    // Mapping from chat address to ChatInfo struct
    mapping(address => ChatInfo) public chats;

    // Mapping from user address to their chat contract addresses
    mapping(address => address[]) public userChats;

    event ChatCreated(
        address indexed author,
        address indexed recipient,
        address chatContract,
        uint256 createdAt
    );

    /// @notice Creates a new chat between the caller and the recipient
    /// @param recipient The address of the chat recipient
    /// @return chatContract The address of the created chat contract
    function createChat(address recipient) external returns (address) {
        require(recipient != address(0), "Invalid recipient address");
        require(recipient != msg.sender, "Cannot create chat with yourself");

        // Deploy new Chat contract
        Chat newChatContract = new Chat(msg.sender, recipient);
        address chatContractAddress = address(newChatContract);

        ChatInfo memory newChat = ChatInfo({
            chatContract: chatContractAddress,
            author: msg.sender,
            recipient: recipient,
            createdAt: block.timestamp,
            exists: true
        });

        chats[chatContractAddress] = newChat;
        userChats[msg.sender].push(chatContractAddress);
        userChats[recipient].push(chatContractAddress);

        emit ChatCreated(
            msg.sender,
            recipient,
            chatContractAddress,
            block.timestamp
        );

        return chatContractAddress;
    }

    /// @notice Get all chats of the caller
    /// @return ChatInfo[] Array of chats where user is either author or recipient
    function getUserChats() external view returns (ChatInfo[] memory) {
        address user = msg.sender;
        address[] memory chatAddresses = userChats[user];
        ChatInfo[] memory userChatList = new ChatInfo[](chatAddresses.length);

        for (uint256 i = 0; i < chatAddresses.length; i++) {
            userChatList[i] = chats[chatAddresses[i]];
        }

        return userChatList;
    }

    /// @notice Get chat by address
    /// @param chatContract The address of the chat contract
    /// @return ChatInfo The chat details
    function getChat(
        address chatContract
    ) external view returns (ChatInfo memory) {
        require(chats[chatContract].exists, "Chat does not exist");
        return chats[chatContract];
    }
}
