/// Imports
import 'dart:async';
import 'package:solana_web3/solana_web3.dart' as web3;

/// Subscribe to an account and receive notifications when it changes.
Future<void> accountSubscribe() async {

    // Create a connection to the devnet cluster.
    final cluster = web3.Cluster.devnet;
    final connection = web3.Connection(cluster);

    print('Create a new account...\n');

    // Create a new wallet (with zero balance).
    final wallet = web3.Keypair.generateSync();
    final address = wallet.pubkey;

    /// The amount sent to [address].
    final airdropAmount = web3.solToLamports(1).toInt();

    // Use Completer to keep the function alive until a notification is received.
    final Completer completer = Completer();

    try {
      // Subscribe to receive notifications when the account data changes.
      final _subscription = await connection.accountSubscribe(
        address,
        onData: (final web3.AccountInfo accountInfo) {
          print('Account Notification Received ${accountInfo.toJson()}\n');
          assert(accountInfo.lamports == airdropAmount);
          completer.complete();
      });

      print('Airdrop $airdropAmount lamports to $address...\n');

      // Check the account balances before making the transfer.
      final airdropSignature = await connection.requestAirdrop(address, airdropAmount);
      await connection.confirmTransaction(airdropSignature);
      
    } catch (error, stackTrace) {
      completer.completeError(error, stackTrace);
    }

    return completer.future;
}