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

## Example

1. Import the package and [System Program](https://docs.solana.com/developing/runtime-facilities/programs#system-program).

```dart
import 'package:solana_web3/solana_web3.dart' as web3;
import 'package:solana_web3/programs/system.dart';
```

2. Connect to a Solana cluster.

```dart
final cluster = web3.Cluster.devnet;
final connection = web3.Connection(cluster);
```

3. Create a new wallet and airdrop [amount] tokens to the address.

```dart
/// NOTE: Keep the value of [amount] low (e.g. 1 or 2).
/// 
/// WARNING: Airdrops cannot be performed on the mainnet.
Future<web3.Keypair> createWalletWithBalance(
  final web3.Connection connection, { 
  required final int amount, 
}) async {

  // Create a new wallet and get its public address.
  final wallet = web3.Keypair.generate();
  final address = wallet.publicKey;

  // Airdrop some test tokens to the wallet address.
  // NOTE: Airdrops cannot be performed on the mainnet.
  if (amount > 0) {
    final lamports = web3.lamportsPerSol * amount;
    final transactionSignature = await connection.requestAirdrop(address, lamports);
    await connection.confirmTransaction(transactionSignature);
  }

  return wallet;
}
```

4. Transfer lamports from one account to another using the [System Program](https://docs.solana.com/developing/runtime-facilities/programs#system-program).

```dart
print('Creating accounts...\n');

// Create a new wallet to transfer tokens from.
final wallet1 = await createWalletWithBalance(connection, amount: 2);
final address1 = wallet1.publicKey;

// Create a new wallet to transfer tokens to.
final wallet2 = await createWalletWithBalance(connection, amount: 0);
final address2 = wallet2.publicKey;

// Check the account balances before making the transfer.
final balance = await connection.getBalance(wallet1.publicKey);
print('Account $address1 has an initial balance of $balance lamports.');
print('Account $address2 has an initial balance of 0 lamports.\n');

// Create a System Program instruction to transfer 1 SOL from [address1] to [address2].
final transaction = web3.Transaction();
transaction.add(
    SystemProgram.transfer(
        fromPublicKey: address1, 
        toPublicKey: address2, 
        lamports: web3.solToLamports(1),
    ),
);

// Send the transaction to the cluster and wait for it to be confirmed.
print('Send and confirm transaction...\n');
await connection.sendAndConfirmTransaction(
    transaction, 
    signers: [wallet1], // Fee payer + transaction signer.
);

// Check the updated account balances.
final wallet1balance = await connection.getBalance(wallet1.publicKey);
final wallet2balance = await connection.getBalance(wallet2.publicKey);
print('Account $address1 has an updated balance of $wallet1balance lamports.');
print('Account $address2 has an updated balance of $wallet2balance lamports.');
```

5. Close the connection.

```dart
connection.disconnect();
```

## Bugs and Feature Requests

### Bugs
Please feel free to report any bugs found by opening an [issue](https://github.com/merigo-labs/solana-web3/issues/new?template=bug_report.md).

### Feature Requests
If you'd like to see a feature added to the library, let us know by raising a [ticket](https://github.com/merigo-labs/solana-web3/issues/new?template=feature_request.md).

