// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title Chat
/// @notice Contract for handling messages between two participants
contract Chat {
    address public immutable author;
    address public immutable recipient;

    event MessageSent(
        address indexed sender,
        string message,
        uint256 timestamp
    );

    constructor(address _author, address _recipient) {
        require(_author != address(0), "Invalid author address");
        require(_recipient != address(0), "Invalid recipient address");
        require(
            _author != _recipient,
            "Author and recipient must be different"
        );

        author = _author;
        recipient = _recipient;
    }

    /// @notice Send a message in the chat
    /// @param message The content of the message
    function sendMessage(string calldata message) external {
        require(
            isParticipant(msg.sender),
            "Only chat participants can send messages"
        );
        require(bytes(message).length > 0, "Message cannot be empty");

        emit MessageSent(msg.sender, message, block.timestamp);
    }

    /// @notice Check if an address is a participant in this chat
    /// @param user Address to check
    /// @return bool True if the address is either author or recipient
    function isParticipant(address user) public view returns (bool) {
        return user == author || user == recipient;
    }
}
