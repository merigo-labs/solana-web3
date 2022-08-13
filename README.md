<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

Solana Dart API built on Solana's [JSON RPC API](https://docs.solana.com/developing/clients/jsonrpc-api). The library is based on the popular Javascript library [solana-web3.js](https://github.com/solana-labs/solana-web3.js).

## Features

The library includes the following features:

* Compute Budget Program
* ED25519 Program
* JSON RPC API
* Stake Program
* System Program

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder. 

```dart
import 'package:solana_web3/solana_web3.dart' as web3;

// Connect to the devnet cluster.
final cluster = web3.Cluster.devnet;
final connection = web3.Connection(cluster);

// Create a new account and send SOL to the wallet address.
final keypair = web3.Keypair.generate();
const amount = web3.LAMPORTS_PER_SOL * 2; // Keep this value low.
print('Airdrop $amount lamport(s) to account ${keypair.publicKey}...');
final transactionSignature = await connection.requestAirdrop(keypair.publicKey, amount);
await connection.confirmTransaction(transactionSignature);

// Get the account balance.
final balance = await connection.getBalance(keypair.publicKey);
print('The account ${keypair.publicKey} has a balance of $balance lamport(s).');
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to 
contribute to the package, how to file issues, what response they can expect 
from the package authors, and more.


## Bugs
Please report all bugs on the GitHub [issues](https://github.com/merigo-labs/solana-web3/issues) page.