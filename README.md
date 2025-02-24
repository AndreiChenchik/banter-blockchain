# Banter Blockchain

A decentralized messaging and token platform built with Solidity and Foundry. This project implements both a custom ERC20 token (BanterCoin) and a decentralized chat system that can be used by web3 applications.

## Core Components

### 1. BanterCoin (BANT)
- ERC20 compliant token implementation
- Initial supply of 1,000,000 BANT tokens
- Built with OpenZeppelin Contracts v5.2.0
- Secure and auditable token transfers

### 2. Chat System
- Decentralized chat functionality through smart contracts
- `ChatList` contract for managing user conversations
- `Chat` contract for handling individual chat instances
- Features:
  - One-to-one messaging
  - Message history stored on-chain
  - Participant verification
  - Event-based message tracking

## Technical Stack

- [Foundry](https://book.getfoundry.sh/) - Development framework
- [OpenZeppelin Contracts](https://www.openzeppelin.com/contracts) - Battle-tested smart contract library
- Solidity v0.8.22
- [just](https://github.com/casey/just) - Command runner for deployment scripts

## Getting Started

### Prerequisites

1. Install Foundry by following the [official installation guide](https://book.getfoundry.sh/getting-started/installation)
2. Install `just` command runner:
   ```bash
   # macOS
   brew install just

   # Linux
   # See https://github.com/casey/just#installation
   ```
3. Clone this repository

### Setup

Initialize the project and install dependencies:

```bash
bash setup.sh
```

### Testing

Run the test suite:

```bash
forge test
```

### Deployment

The project uses `just` commands for deployment with proper environment configuration.

1. Create a `.env` file in the project root with the following variables:
```env
# RPC Configuration
TENDERLY_RPC_URL=your_rpc_url
TENDERLY_CHAIN_ID=your_chain_id
TENDERLY_API_KEY=your_api_key

# Wallet Configuration
KEY_NAME=your_key_name
KEY_ADDRESS=your_wallet_address
```

2. Deploy the contracts using the justfile commands:
```bash
# Deploy BanterCoin
just coin_rpc_deploy

# Deploy ChatList
just chatlist_tenderly_deploy
```

3. Verify the Chat contract after creation:
```bash
# Verify a Chat contract
just chat_tenderly_verifyContract CHAT_ADDRESS OWNER_ADDRESS RECIPIENT_ADDRESS
```

### Contract Interactions

The project provides several commands for interacting with deployed contracts:

```bash
# Create a new chat
just chatlist_tenderly_createChat CHATLIST_ADDRESS RECIPIENT_ADDRESS

# Extract a Chat address from transaction receipt
just chatlist_tenderly_extractChatAddress TX_HASH

# Send a message in a chat
just chat_tenderly_sendMessage CHAT_ADDRESS "Your message here"

# Create a chat and verify it in one command
just chatlist_tenderly_createChain CHATLIST_ADDRESS RECIPIENT_ADDRESS
```

## Smart Contract Architecture

### BanterCoin Contract
- Standard ERC20 implementation
- Fixed initial supply
- Built-in decimals support
- Transfer and approval functionality

### ChatList Contract
- Main registry for all chat instances
- Manages chat creation and lookup
- Maintains user-to-chat mappings
- Prevents duplicate chats between the same users

### Chat Contract
- Individual chat instance
- Message sending functionality
- Participant verification
- Event emission for message tracking

## Security

- Contract security contact: andrei@chenchik.me
- Built with OpenZeppelin Contracts for battle-tested security
- Follows Solidity best practices and patterns
- Comprehensive test coverage

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License.
