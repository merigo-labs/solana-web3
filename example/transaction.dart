import 'package:solana_web3/solana_web3.dart' as web3;

void transaction() async {
  // Connect to a cluster.
  final cluster = web3.Cluster.devnet;
  final connection = web3.Connection(cluster);

  // Create two new accounts.
  final account1 = web3.Keypair.generate();
  final address1 = account1.publicKey;
  final account2 = web3.Keypair.generate();
  final address2 = account2.publicKey;

  // Fund the test account with SOL.
  const amount = web3.LAMPORTS_PER_SOL * 2; // Keep this value low.
  print('Airdrop $amount lamports to each account [$address1, $address2]...');
  final transactionSignature1 = await connection.requestAirdrop(address1, amount);
  await connection.confirmTransaction(transactionSignature1);
  final transactionSignature2 = await connection.requestAirdrop(address2, amount);
  await connection.confirmTransaction(transactionSignature2);

  // Send 1 SOL from account1 to account2.
  print('Sending transaction...');
  final transaction = web3.Transaction();
  transaction.add(
    web3.SystemProgram.transfer(
      fromPublicKey: address1, 
      toPublicKey: address2, 
      lamports: web3.solToLamports(1),
    ),
  );
  await connection.sendAndConfirmTransaction(
    transaction, 
    signers: [account1],
  );

  // Get the account balances.
  final balance1 = await connection.getBalance(account1.publicKey);
  print('${account1.publicKey} = $balance1 lamports.');
  final balance2 = await connection.getBalance(account2.publicKey);
  print('${account2.publicKey} = $balance2 lamports.');
}