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

The Solana Dart API built on Solana's [JSON RPC API](https://docs.solana.com/developing/clients/jsonrpc-api).

Android and iOS supported.

## Features

The library is modelled on the [solana-web3.js](https://github.com/solana-labs/solana-web3.js) Javascript API and includes the following features:

* Compute Budget Program
* ED25519 Program
* JSON RPC API
* Stake Program
* System Program

## Usage

Import the package (after adding it to your [pubspec.yaml](https://pub.dev/packages/solana_web3/install) file).

```dart
import 'package:solana_web3/solana_web3.dart' as web3;
```

Connect to a Solana cluster.

```dart
final cluster = web3.Cluster.devnet;
final connection = web3.Connection(cluster);
```

### Example 1
Invoke a [JSON RPC API](https://docs.solana.com/developing/clients/jsonrpc-api) method.

```dart
// Create a new wallet.
final wallet = web3.Keypair.generate();
final address = wallet.publicKey;

// Airdrop some test tokens to the wallet address.
// NOTE: Airdrops cannot be performed on the mainnet.
const amount = web3.lamportsPerSol * 2; // Keep this value low.
print('Airdrop $amount lamports to account $address...');
final airdropSignature = await connection.requestAirdrop(address, amount);
await connection.confirmTransaction(airdropSignature);

// Check the account balance.
final balance = await connection.getBalance(address);
print('The account $address has a balance of $balance lamports');
```

### Example 2
Transfer lamports from one account to another using the [System Program](https://docs.solana.com/developing/runtime-facilities/programs#system-program).

```dart
// Import the System Program.
import 'package:solana_web3/programs/system.dart';

// Create a new wallet to transfer tokens from.
final fromWallet = web3.Keypair.generate();
final fromAddress = fromWallet.publicKey;

// Create a new wallet to transfer tokens to.
final toWallet = web3.Keypair.generate();
final toAddress = toWallet.publicKey;

// Airdrop some test tokens to the wallet address.
// NOTE: Airdrops cannot be performed on the mainnet.
const amount = web3.lamportsPerSol * 2; // Keep this value low.
print('Airdrop $amount lamports to account $fromAddress...');
final airdropSignature = await connection.requestAirdrop(fromAddress, amount);
await connection.confirmTransaction(airdropSignature);

// Create a System Program instruction to transfer SOL.
final transaction = web3.Transaction();
transaction.add(
    SystemProgram.transfer(
        fromPublicKey: fromAddress, 
        toPublicKey: toAddress, 
        lamports: web3.solToLamports(1),
    ),
);

// Send the transaction to the cluster and wait for it to be confirmed.
print('Sending transaction...');
await connection.sendAndConfirmTransaction(
    transaction, 
    signers: [fromWallet], // Fee payer + transaction signer.
);

// Check the account balances.
final fromBalance = await connection.getBalance(fromAddress);
final toBalance = await connection.getBalance(toAddress);
print('$fromAddress = $fromBalance lamports.');
print('$toAddress = $toBalance lamports.');
```

Close the connection.

```dart
connection.disconnect();
```

## Bugs and Feature Requests

### Bugs
Please feel free to report any bugs found by opening an [issue](https://github.com/merigo-labs/solana-web3/issues/new?template=bug_report.md).

### Feature Requests
If you'd like to see a feature added to the library, let us know by raising a [ticket](https://github.com/merigo-labs/solana-web3/issues/new?template=feature_request.md).

