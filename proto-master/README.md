# IPFS + Ethereum Storage

We will create a simple datastore solution using IPFS and Ethereum. IPFS provides a convenient interface for distributed data storage, with a hash-based content address for reference to our file. This address will be stored in our smart contract on a private Ethereum blockchain. To retrieve the latest data, we will fetch the address from our blockchain and query IPFS for the associated file.

## Build Guide

This repository has the following dependencies:
 * [IPFS](https://ipfs.io) - the Interplanetary File System
 * [Geth](https://ethereum.org/cli) - the Go implementation of Ethereum

### Install Geth

__Mac:__ For Mac users, install [Homebrew](https://brew.sh/) and update:
```
brew update
brew upgrade
```
Then run:
```
brew tap ethereum/ethereum
brew install ethereum
```

__Windows:__ For Windows users, download the [latest stable release](https://geth.ethereum.org/downloads/), extract it, download the zip file, extract _geth.exe_ from zip, open a command terminal and type:
```
chdir <path to extracted binary>
open geth.exe
```

__Linux:__ For Ubuntu users, run:
```
sudo apt-get install software-properties-common
sudo add-apt-repository -y ppa:ethereum/ethereum
sudo apt-get update
sudo apt-get install ethereum
```

### Install IPFS

__Mac/Linux:__ For Mac and Linux users, download the [prebuilt package](https://ipfs.io/docs/install/), then untar and move the binary to your executables `$PATH` as follows:
```
tar xvfz go-ipfs.tar.gz
mv go-ipfs/ipfs /usr/local/bin/ipfs
```

__Windows:__ For Windows users, download the [prebuilt package](https://ipfs.io/docs/install/), then unzip and move `ipfs.exe` to your `%PATH%`.

To test that your IPFS installation worked, in your terminal (Mac/Linux) or command prompt (Windows) window, run:
```
ipfs help
```
The help menu describing IPFS actions will be printed out.


## Initialize an Ethereum node

We will start by setting up a private Ethereum blockchain on your local machine.

### Setup Geth

Create a new directory for your private blockchain. In your terminal (Mac/Linux) or command prompt (Windows) window, navigate to the directory and create a new account:
```
geth --datadir="./" account new
```
Enter a password when prompted for your local Ethereum account. Geth will create a keystore directory and store the account file in the keystore.

### Genesis Block

Setting up a private blockchain requires defining a genesis block, which sets the initial parameters and token distribution.

In the directory containing your account, copy/paste/save the following JSON into a file called `genesisblock.json`:
```
{
    "config": {
        "chainID"       : 10,
        "homesteadBlock": 0,
        "eip155Block":    0,
        "eip158Block":    0
    },
    "nonce": "0x01",
    "difficulty": "0x20000",
    "mixhash": "0x00000000000000000000000000000000000000647572616c65787365646c6578",
    "coinbase": "0x0000000000000000000000000000000000000000",
    "timestamp": "0x00",
    "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
    "extraData": "0x00",
    "gasLimit": "0x2FEFD8",
    "alloc": {
    }
}
```
This will be block 0 of your private blockchain. If you ever wish to have others join this network, they will need this genesis block as well.

We will now instantiate the blockchain network and load the geth console:
```
geth --datadir="./" init genesisblock.json
geth --datadir="./" --networkid 23422  --rpc --rpccorsdomain="*" --rpcport="8545" --minerthreads="1" --mine --nodiscover --maxpeers=0 --unlock 0 console
```
The `--datadir` flag tells geth the path for storing blockchain data. The `--networkid` flag gives your private blockchain a unique reference ID. The `--rpc` and related flags enable remote procedure call (RPC) functionality for web3. The `--minerthreads` flag enables the specified number of CPU threads for mining. The `--mine` flag indicates the mine function for processing transactions and propagating smart contracts through the network. The `--nodiscover` and `--maxpeers` flag disables peer discovery mechanisms. The `--unlock 0` flag unlocks the first account in the system. The `--console` flag enables the REPL terminal.

As this is our first time running the `--mine` flag, wait for the DAG file to be generated. You will see `Generating DAG: xx%` for a couple minutes. This is a one-time operation.

## Initialize IPFS

While we wait for the DAG to be generated, let's setup IPFS. Start by initializing IPFS and modifying CORS restrictions:
```
ipfs init
ipfs config --json API.HTTPHeaders.Access-Control-Allow-Origin '["*"]'
ipfs config --json Gateway.HTTPHeaders.Access-Control-Allow-Origin '["*"]'
```

Now start the daemon:
```
ipfs daemon
```

## Run the Application

Open `storage.html` and follow the instructions on the front page.

