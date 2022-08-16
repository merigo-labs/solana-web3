import 'package:solana_web3/solana_web3.dart' as web3;

void main(final List<String> arguments) async {
  // Create a connection to the devnet cluster.
  final cluster = web3.Cluster.devnet;
  final connection = web3.Connection(cluster);
  
  // Create a new wallet.
  final wallet = web3.Keypair.generate();
  final address = wallet.publicKey;

  // Airdrop some test tokens to the wallet address.
  // NOTE: Airdrops cannot be performed on the mainnet.
  const amount = web3.lamportsPerSol * 2; // Keep this value low.
  print('Airdrop $amount lamports to account $address...');
  final transactionSignature = await connection.requestAirdrop(address, amount);
  await connection.confirmTransaction(transactionSignature);

  // Check the account balance.
  final balance = await connection.getBalance(address);
  print('The account $address has a balance of $balance lamports');
}