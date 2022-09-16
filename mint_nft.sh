#!/bin/sh

gum style --foreground 112 "This will create a candy machine and mint all of the NFTs in it then close the candy machine"

gum style --foreground 212 "Choose network to deploy"
NETWORK=$(gum choose "devnet" "testnet" "mainnet-beta")
gum style --foreground 212 "Network: $NETWORK"

echo

solana config set --url $NETWORK

echo

gum style --foreground 212 "Choose deployer wallet"
DEPLOYER_WALLET_PATH=./keys/$(ls ./keys | gum choose)
gum style --foreground 212 "Deployer wallet: $(solana address -k $DEPLOYER_WALLET_PATH)"
gum style --foreground 212 "Wallet balance: $(solana balance -k $DEPLOYER_WALLET_PATH)"

echo

gum style --foreground 112 "Validate assets"

# validate asset
sugar validate

if [ $? -eq 1 ]
then
  exit 1
fi

echo

gum style --foreground 112 "Uploading assets to arweve"
# upload asset to arweve
sugar upload -k $DEPLOYER_WALLET_PATH

if [ $? -eq 1 ]
then
  exit 1
fi

echo

gum style --foreground 112 "Deploy Candy Machine to $NETWORK"
# deploy candy machine
sugar deploy -k $DEPLOYER_WALLET_PATH

if [ $? -eq 1 ]
then
  exit 1
fi

echo

gum style --foreground 112 "Mint NFTs in Candy Machine"
# mint all NFTs
sugar mint --number $(gum input --placeholder "mint amount") -k $DEPLOYER_WALLET_PATH

if [ $? -eq 1 ]
then
  exit 1
fi

echo

gum style --foreground 112 "Close the Candy Machine"
# close the Candy Machine
sugar withdraw -k $DEPLOYER_WALLET_PATH

echo

gum style --foreground 212 "Deployer wallet: $(solana address -k $DEPLOYER_WALLET_PATH)"
gum style --foreground 212 "Wallet balance: $(solana balance -k $DEPLOYER_WALLET_PATH)"
