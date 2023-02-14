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

### Dart implementation of Solana's [JSON RPC API](https://docs.solana.com/developing/clients/jsonrpc-api).

<em>Android and iOS support.</em>

<br>

<img src="https://github.com/merigo-labs/example-apps/blob/master/docs/images/solana_wallet_provider_authorize.gif?raw=true" alt="Authorize App" height="400">
<br>

*Screenshot of [solana_wallet_provider](https://pub.dev/packages/solana_wallet_provider)*

<br>

### Implements the following programs:

- [System Program](https://docs.solana.com/developing/runtime-facilities/programs#system-program)
- [Token Program](https://spl.solana.com/token)
- [Associated Token Program](https://spl.solana.com/associated-token-account)
- [Stake Program](https://docs.solana.com/developing/runtime-facilities/programs#stake-program)
- [Stake Pool Program](https://spl.solana.com/stake-pool)
- [Memo Program](https://spl.solana.com/memo)
- Compute Budget Program
- [ED25519 Program](https://docs.solana.com/developing/runtime-facilities/programs#ed25519-program)

<br>

### Features include:

- Signing Transactions.
- Sending Transactions.
- Signing Messages.
- Websocket Notification Subscriptions (e.g. Account changes).
- Keypair Generation.
- Borsh Serialization.

<br>

## Example: Transfer SOL

```dart
/// Imports
import 'package:solana_web3/solana_web3.dart' as web3;
import 'package:solana_web3/programs/system.dart';

/// Transfer tokens from one wallet to another.
void main(final List<String> _arguments) async {

  // Create a connection to the devnet cluster.
  final cluster = web3.Cluster.devnet;
  final connection = web3.Connection(cluster);

  // Create a wallet to transfer tokens from.
  print('Creating accounts...\n');
  final wallet1 = web3.Keypair.generate();
  final address1 = wallet1.publicKey;

  // Credit the wallet that will be sending tokens.
  await connection.requestAirdropAndConfirmTransaction(
    address1, 
    web3.solToLamports(2).toInt(),
  );

  // Create a wallet to transfer tokens to.
  final wallet2 = web3.Keypair.generate();
  final address2 = wallet2.publicKey;

  // Check the account balances before making the transfer.
  final balance = await connection.getBalance(address1);
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
  final balance1 = await connection.getBalance(address1);
  final balance2 = await connection.getBalance(address2);
  print('Account $address1 has an updated balance of $balance1 lamports.');
  print('Account $address2 has an updated balance of $balance2 lamports.');
}
```

<br>

## Bugs
Report a bug by opening an [issue](https://github.com/merigo-labs/solana-web3/issues/new?template=bug_report.md).

## Feature Requests
Request a feature by raising a [ticket](https://github.com/merigo-labs/solana-web3/issues/new?template=feature_request.md).

