// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title Chat
/// @notice Contract for handling messages between two participants
contract Chat {
    // Custom errors
    error OnlyChatParticipantsCanSendMessages();
    error MessageCannotBeEmpty();

    address public immutable author;
    address public immutable recipient;

    event MessageSent(
        address indexed sender,
        string message,
        uint256 timestamp
    );

    constructor(address _author, address _recipient) {
        // Note: Redundant validations removed as they're already performed in ChatList
        // These were duplicating checks from ChatList.createChat() which is the only contract
        // that creates Chat instances

        author = _author;
        recipient = _recipient;
    }

    /// @notice Send a message in the chat
    /// @param message The content of the message
    function sendMessage(string calldata message) external {
        if (msg.sender != author && msg.sender != recipient)
            revert OnlyChatParticipantsCanSendMessages();
        if (bytes(message).length == 0) revert MessageCannotBeEmpty();

        emit MessageSent(msg.sender, message, block.timestamp);
    }
}
