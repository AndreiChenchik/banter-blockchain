# 🏗 Banter Blockchain

<h4 align="center">
  A decentralized messaging and token platform built on Ethereum
</h4>

🧪 Banter Blockchain implements both a custom ERC20 token (BanterCoin) and a decentralized chat system that can be used by web3 applications, built with Scaffold-ETH 2 toolkit.

⚙️ Built using NextJS, RainbowKit, Hardhat, Wagmi, Viem, and Typescript.

## Core Components

### 1. BanterCoin (BANT)
- ERC20 compliant token implementation
- Initial supply of 1,000,000 BANT tokens
- Built with OpenZeppelin Contracts v5.0.0
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

## Smart Contract Architecture

### BanterCoin Contract
- Standard ERC20 implementation with fixed initial supply
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

## Requirements

Before you begin, you need to install the following tools:

- [Node (>= v20.18.3)](https://nodejs.org/en/download/)
- Yarn ([v1](https://classic.yarnpkg.com/en/docs/install/) or [v2+](https://yarnpkg.com/getting-started/install))
- [Git](https://git-scm.com/downloads)

## Getting Started

To get started with Banter Blockchain using Scaffold-ETH 2, follow the steps below:

1. Clone this repository and install dependencies:

```bash
git clone https://github.com/yourusername/banter-blockchain.git
cd banter-blockchain
yarn install
```

2. Run a local network in the first terminal:

```bash
yarn chain
```

This command starts a local Ethereum network using Hardhat. The network runs on your local machine and can be used for testing and development.

3. On a second terminal, deploy the contracts:

```bash
yarn deploy
```

This command deploys the BanterCoin and ChatList contracts to the local network. The contracts are located in `packages/hardhat/contracts` and can be modified to suit your needs.

4. On a third terminal, start your NextJS app:

```bash
yarn start
```

Visit your app on: `http://localhost:3000`. You can interact with your smart contracts using the `Debug Contracts` page.

## Testing

Run the test suite to ensure all contracts are functioning correctly:

```bash
yarn test
```

The test suite includes tests for all three contracts:
- BanterCoin token functionality
- Chat messaging capabilities
- ChatList management features

## Deployment to a Live Network

To deploy to a testnet or mainnet:

1. Set up your environment variables:
   - Create or modify the `.env` file in the `packages/hardhat` directory
   - Add your private key and API keys for the desired network

2. Deploy to your chosen network:

```bash
yarn deploy --network <network-name>
```

Available networks include: sepolia, arbitrum, optimism, polygon, base, etc. (See `packages/hardhat/hardhat.config.ts` for all options)

3. After deployment, the contracts will be automatically verified on the respective block explorers if configured correctly.

## Contract Interactions

Once deployed, you can interact with the contracts through the Scaffold-ETH 2 UI or programmatically:

### BanterCoin
- Check your token balance
- Transfer tokens to other addresses
- Approve spending by other contracts

### ChatList
- Create new chat instances with other users
- View your list of active chats
- Access individual chat details

### Chat
- Send messages to your chat partner
- View message history through emitted events

## Security

- Contract security contact: andrei@chenchik.me
- Built with OpenZeppelin Contracts for battle-tested security
- Follows Solidity best practices and patterns
- Comprehensive test coverage

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License.