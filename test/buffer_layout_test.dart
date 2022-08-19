/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solana_web3/programs/system.dart';
import 'package:solana_web3/solana_web3.dart' as web3;


/// Buffer Layout Tests
/// ------------------------------------------------------------------------------------------------

void main() {

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

  test('buffer layout', () async {
    
    WidgetsFlutterBinding.ensureInitialized();

      // Create a connection to the devnet cluster.
  final cluster = web3.Cluster.devnet;
  final connection = web3.Connection(cluster);
    print('Creating accounts...\n');

// Create a new wallet to transfer tokens from.
final wallet1 = await createWalletWithBalance(connection, amount: 2);
final address1 = wallet1.publicKey;

// Create a new wallet to transfer tokens to.
final wallet2 = await createWalletWithBalance(connection, amount: 0);
final address2 = wallet2.publicKey;

// Check the account balances before sending a transaction.
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
  });
}