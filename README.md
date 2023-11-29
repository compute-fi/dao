## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```



# What do we want: 

1. We want a contract to be controlled by a DAO
2. Every transaction that the DAO want to send has to be voted on
3. We will use ERC-20 token for voting (research better models - which governance token will I will use - replace this with the dNFT or create a token which is related to the funder's dNFT and a project so that for every project the user is able to vote only once for a proposal)/

> Some kind of token[1 user (dNFT) + 1 project + 1 proposal] => 1 vote 

## Different Branches
Multiple branches for different functionalities 
1. for ERC-20 based Governance Token (check [dao-erc20]() branch)
2. for ERC-721 based Governance Token (This is the one we actually want - we will have to modify it based on our needs) (check main branch)

[ERC721 DAO](https://www.covalenthq.com/docs/unified-api/guides/what-are-daos-and-how-do-they-work-part-2/)

The Next Step in this process is: 
- Deploy governance contract and then the governor contract on testnet and then using 
    https://www.tally.xyz/add-a-dao
add the dao to tally and check it out how it is working.  

<!-- [create an NFT DAO](https://blog.tally.xyz/how-to-create-an-nft-dao-47669a9e4e3a) -->

[Governance Token vs Utility Token](https://www.coingecko.com/learn/governance-vs-utility-tokens) 

##### Deployed contract addresses in sepolia
Governance Token: 0x8d1B4cDc4b9d461b64E0cf92A083Dc070EE90eD1
Timelock: 0x5041C6A71Af779ff3301cf39EE7e4D6c7Aa0f0F4
Governor: 0xE4158af9243f0D99d17580C80b60B2f56322cE96

Target: Box: 0x29CDB0cfBb20ebeF190c4BFFA59e550ff4394922


3. upgradable smart contracts (Governor contract) - add it later on if time permits. 
4. voting throught snapshot.js sdk

