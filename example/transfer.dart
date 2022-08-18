import 'package:solana_web3/programs/system.dart';
import 'package:solana_web3/solana_web3.dart' as web3;

void transfer() async {
  // Create a connection to the devnet cluster.
  final cluster = web3.Cluster.devnet;
  final connection = web3.Connection(cluster);

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
}