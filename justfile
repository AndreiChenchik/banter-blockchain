#!/usr/bin/env -S just --justfile

set dotenv-load

[group: 'deploy']
coin_rpc_deploy:
	FOUNDRY_ETHERSCAN_UNKNOWN_CHAIN="{chain = ${TENDERLY_CHAIN_ID}, key = \"${TENDERLY_API_KEY}\", url = \"${TENDERLY_RPC_URL}/verify/etherscan\"}" \
		forge script script/BanterCoin.s.sol:BanterCoinScript \
			--slow \
			--rpc-url $TENDERLY_RPC_URL \
			--account $KEY_NAME \
			--sender $KEY_ADDRESS \
			--broadcast \
			--verify \
			--etherscan-api-key $TENDERLY_API_KEY \
			--verifier-url $TENDERLY_RPC_URL/verify/etherscan \
			-vvvv
