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

<img src="https://github.com/merigo-labs/example-apps/blob/master/docs/images/solana_wallet_provider_authorize.gif?raw=true" alt="Authorize App" height="600">
<br>

*Screenshot of [solana_wallet_provider](https://pub.dev/packages/solana_wallet_provider)*

<br>

### Implements the following programs:

- [System Program](https://docs.solana.com/developing/runtime-facilities/programs#system-program)
- [Token Program](https://spl.solana.com/token)
- [Associated Token Program](https://spl.solana.com/associated-token-account)
- [Stake Program](https://docs.solana.com/developing/runtime-facilities/programs#stake-program)
- [Stake Pool Program](https://spl.solana.com/stake-pool)
- [Metaplex Token Metadata]()
- [Memo Program](https://spl.solana.com/memo)
- Compute Budget Program
- [ED25519 Program](https://docs.solana.com/developing/runtime-facilities/programs#ed25519-program)
- [Address Lookup Table](https://docs.solana.com/developing/lookup-tables)

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

    print('Creating accounts...\n');

    // Create a new wallet to transfer tokens from.
    final wallet1 = web3.Keypair.generateSync();
    final address1 = wallet1.pubkey;

    // Create a new wallet to transfer tokens to.
    final wallet2 = web3.Keypair.generateSync();
    final address2 = wallet2.pubkey;

    // Fund the sending wallet.
    await connection.requestAndConfirmAirdrop(
      wallet1.pubkey, 
      solToLamports(2).toInt(),
    );

    // Check the account balances before making the transfer.
    final balance = await connection.getBalance(wallet1.pubkey);
    print('Account $address1 has an initial balance of $balance lamports.');
    print('Account $address2 has an initial balance of 0 lamports.\n');

    // Fetch the latest blockhash.
    final BlockhashWithExpiryBlockHeight blockhash = await connection.getLatestBlockhash();

    // Create a System Program instruction to transfer 0.5 SOL from [address1] to [address2].
    final transaction = web3.Transaction.v0(
      payer: wallet1.pubkey,
      recentBlockhash: blockhash.blockhash,
      instructions: [
        SystemProgram.transfer(
          fromPubkey: address1, 
          toPubkey: address2, 
          lamports: web3.solToLamports(0.5),
        ),
      ]
    );

    // Sign the transaction.
    transaction.sign([wallet1]);

    // Send the transaction to the cluster and wait for it to be confirmed.
    print('Send and confirm transaction...\n');
    await connection.sendAndConfirmTransaction(
      transaction, 
    );

    // Check the updated account balances.
    final wallet1balance = await connection.getBalance(wallet1.pubkey);
    final wallet2balance = await connection.getBalance(wallet2.pubkey);
    print('Account $address1 has an updated balance of $wallet1balance lamports.');
    print('Account $address2 has an updated balance of $wallet2balance lamports.');
}
```

<br>

## Bugs
Report a bug by opening an [issue](https://github.com/merigo-labs/solana-web3/issues/new?template=bug_report.md).

## Feature Requests
Request a feature by raising a [ticket](https://github.com/merigo-labs/solana-web3/issues/new?template=feature_request.md).

