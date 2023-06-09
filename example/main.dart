/// Imports
import 'package:solana_web3/solana_web3.dart' as web3;
import 'package:solana_web3/programs.dart' show SystemProgram;
import 'package:solana_web3/src/encodings/lamports.dart';
import 'package:solana_web3/src/rpc/models/blockhash_with_expiry_block_height.dart';

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