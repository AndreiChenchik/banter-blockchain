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

    // Mapping to track existing chats between users (hash of sorted addresses -> chat address)
    mapping(bytes32 => address) private userPairToChat;

    event ChatCreated(
        address indexed author,
        address indexed recipient,
        address chatContract,
        uint256 createdAt
    );

    /// @notice Get the unique pair hash for two users
    /// @dev Orders addresses to ensure same hash regardless of parameter order
    /// @param user1 First user address
    /// @param user2 Second user address
    /// @return bytes32 Hash representing the unique user pair
    function _getUserPairHash(
        address user1,
        address user2
    ) private pure returns (bytes32) {
        return
            keccak256(
                abi.encodePacked(
                    user1 < user2 ? user1 : user2,
                    user1 < user2 ? user2 : user1
                )
            );
    }

    /// @notice Creates a new chat between the caller and the recipient
    /// @param recipient The address of the chat recipient
    /// @return chatContract The address of the created chat contract
    function createChat(address recipient) external returns (address) {
        require(recipient != address(0), "Invalid recipient address");
        require(recipient != msg.sender, "Cannot create chat with yourself");

        bytes32 pairHash = _getUserPairHash(msg.sender, recipient);
        address existingChat = userPairToChat[pairHash];
        require(
            existingChat == address(0) || !chats[existingChat].exists,
            "Chat already exists between users"
        );

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
        userPairToChat[pairHash] = chatContractAddress;

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
