/// Imports
import 'dart:async';
import 'package:solana_web3/rpc_models/account_info.dart';
import 'package:solana_web3/solana_web3.dart' as web3;

/// Subscribe to an account and receive notifications when it changes.
Future<void> accountSubscribe() async {

  // Create a connection to the devnet cluster.
  final cluster = web3.Cluster.devnet;
  final connection = web3.Connection(cluster);

  print('Create a new account...\n');

  // Create a new wallet (with zero balance).
  final wallet = web3.Keypair.generate();
  final address = wallet.publicKey;

  /// The amount sent to [address].
  final airdropAmount = web3.solToLamports(1).toInt();

  // Use Completer to keep the function alive until a notification is received.
  final Completer completer = Completer();

  try {
    // Subscribe to receive notifications when the account data changes.
    final subscription = await connection.accountSubscribe(address);
    subscription.on((final AccountInfo accountInfo) {
      print('Account Notification ${accountInfo.toJson()}\n');
      assert(accountInfo.lamports == airdropAmount);
      completer.complete();
    });

    print('Airdrop $airdropAmount lamports to $address...\n');

    // Airdrop SOL into the account and wait for confirmation.
    final airdropSignature = await connection.requestAirdropAndConfirmTransaction(
      address, 
      airdropAmount,
    );

    print('Airdrop Signature $airdropSignature');

  } catch (error, stackTrace) {
    completer.completeError(error, stackTrace);
  }

  return completer.future;
}