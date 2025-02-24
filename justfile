#!/usr/bin/env -S just --justfile

set dotenv-load

[group('infra')]
add_new_account KEY_NAME:
	cast wallet import --interactive {{KEY_NAME}}

[group('deploy')]
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

[group('deploy')]
chatlist_tenderly_deploy:
	FOUNDRY_ETHERSCAN_UNKNOWN_CHAIN="{chain = ${TENDERLY_CHAIN_ID}, key = \"${TENDERLY_API_KEY}\", url = \"${TENDERLY_RPC_URL}/verify/etherscan\"}" \
		forge script script/ChatList.s.sol:ChatListScript \
			--slow \
			--rpc-url $TENDERLY_RPC_URL \
			--account $KEY_NAME \
			--sender $KEY_ADDRESS \
			--broadcast \
			--verify \
			--etherscan-api-key $TENDERLY_API_KEY \
			--verifier-url $TENDERLY_RPC_URL/verify/etherscan \
			-vvvv

[group('deploy')]
chat_tenderly_verifyContract CHAT_ADDRESS OWNER_ADDRESS RECIPIENT_ADDRESS:
	FOUNDRY_ETHERSCAN_UNKNOWN_CHAIN="{chain = ${TENDERLY_CHAIN_ID}, key = \"${TENDERLY_API_KEY}\", url = \"${TENDERLY_RPC_URL}/verify/etherscan\"}" \
		forge verify-contract \
			--chain-id $TENDERLY_CHAIN_ID \
			--etherscan-api-key $TENDERLY_API_KEY \
			--constructor-args $(cast abi-encode "constructor(address,address)" {{OWNER_ADDRESS}} {{RECIPIENT_ADDRESS}}) \
			{{CHAT_ADDRESS}} \
			src/Chat.sol:Chat

[group('interact')]
chatlist_tenderly_createChat CHATLIST_ADDRESS RECIPIENT_ADDRESS:
	cast send {{CHATLIST_ADDRESS}} "createChat(address)" {{RECIPIENT_ADDRESS}} \
		--rpc-url $TENDERLY_RPC_URL \
		--account $KEY_NAME \
		--json \
		-vvvv

[group('interact')]
chatlist_tenderly_extractChatAddress TX_HASH:
	cast receipt {{TX_HASH}} \
		--rpc-url $TENDERLY_RPC_URL \
		--json \
		| jq -r '.logs[0].data' \
		| xargs -I {} cast decode-event --sig "_(address, uint256)" "{}" --json \
		| jq -r '.[0]'

[group('interact')]
chat_tenderly_sendMessage CHAT_ADDRESS MESSAGE:
	cast send {{CHAT_ADDRESS}} "sendMessage(string)" "{{MESSAGE}}" \
		--rpc-url $TENDERLY_RPC_URL \
		--account $KEY_NAME

[group('chain')]
chatlist_tenderly_createChain CHATLIST_ADDRESS RECIPIENT_ADDRESS:
	just chatlist_tenderly_createChat {{CHATLIST_ADDRESS}} {{RECIPIENT_ADDRESS}} \
		| jq -r '.transactionHash' \
		| xargs -I {} just chatlist_tenderly_extractChatAddress {} \
		| xargs -I {} just chat_tenderly_verifyContract {} $KEY_ADDRESS {{RECIPIENT_ADDRESS}}
