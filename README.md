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
---

The library is modelled on the [solana-web3.js](https://github.com/solana-labs/solana-web3.js) Javascript API and includes the following features:

* Compute Budget Program
* ED25519 Program
* JSON RPC API
* Stake Program
* System Program

## Usage
---

Invoke a [JSON RPC API](https://docs.solana.com/developing/clients/jsonrpc-api) method.

```dart
import 'package:solana_web3/solana_web3.dart' as web3;

void main() async {
  // Connect to a cluster.
  final cluster = web3.Cluster.devnet;
  final connection = web3.Connection(cluster);

  // Create a new account and get its wallet address.
  final keypair = web3.Keypair.generate();
  final address = keypair.publicKey;

  // Fund the test account with 2 SOL.
  const amount = web3.LAMPORTS_PER_SOL * 2; // Keep this value low.
  print('Airdrop $amount lamports to account $address...');
  final transactionSignature = await connection.requestAirdrop(address, amount);
  await connection.confirmTransaction(transactionSignature);

  // Get the account balance.
  final balance = await connection.getBalance(address);
  print('The account $address has a balance of $balance lamports.');
}
```

## Bugs and Feature Requests
---

### Bugs
Feel free to report any bugs found by opening an [issue](https://github.com/merigo-labs/solana-web3/issues/new?template=bug_report.md).

### Feature Requests
If you'd like a feature added to the library, let us know by raising a [ticket](https://github.com/merigo-labs/solana-web3/issues/new?template=feature_request.md).

