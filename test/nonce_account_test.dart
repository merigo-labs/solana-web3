// /// Imports
// /// ------------------------------------------------------------------------------------------------

// import 'dart:typed_data';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:solana_jsonrpc/jsonrpc.dart';
// import 'package:solana_web3/solana_web3.dart' as web3;
// import 'package:solana_web3/src/crypto/keypair.dart';
// import 'package:solana_web3/src/programs/system/program.dart';
// import 'package:solana_web3/src/rpc/connection.dart';
// import 'package:solana_web3/src/transactions/nonce_account.dart';
// import 'package:solana_web3/types.dart';
// import 'utils.dart' as utils;


// /// Nonce Account Tests
// /// ------------------------------------------------------------------------------------------------

// void main() {

//   WidgetsFlutterBinding.ensureInitialized();

//   final Keypair wallet = utils.wallet;
//   final Connection connection = Connection(Cluster.devnet);
//   final Keypair nonceWallet = Keypair.fromSeckeySync(Uint8List.fromList([
//     160, 107, 64, 72, 178, 116, 194, 76, 161, 10, 25, 18, 28, 2, 130, 225, 
//     119, 218, 151, 87, 233, 229, 165, 35, 27, 70, 21, 9, 195, 155, 206, 167, 
//     245, 84, 3, 73, 22, 97, 15, 51, 70, 123, 193, 116, 5, 148, 121, 197, 
//     66, 127, 38, 138, 206, 221, 119, 104, 26, 216, 137, 219, 228, 145, 2, 183,
//   ]));

//   test('create nonce account', () async {
//     final int rent = await connection.getMinimumBalanceForRentExemption(NonceAccount.length);
//     final tx = SystemProgram.createNonceAccount(
//       fromPubkey: wallet.pubkey, 
//       noncePubkey: nonceWallet.pubkey, 
//       authorizedPubkey: wallet.pubkey, 
//       lamports: rent.toBigInt(),
//     );
//     final TransactionSignature signature = await connection.sendAndConfirmTransaction(
//       tx,
//       signers: [wallet, nonceWallet]
//     );
//     print('Nonce Account Created $signature');
//   });

//   test('get nonce account', () async {
//     final NonceAccount? nonce = await connection.getNonceAccount(nonceWallet.pubkey);
//     print('Nonce Account ${nonce?.toJson()}');
//   });

//   test('get nonce account', () async {
//     print(Commitment.finalized.compareTo(Commitment.processed));  // => 2
//     print(Commitment.finalized.compareTo(Commitment.confirmed));  // => 1
//     print(Commitment.finalized.compareTo(Commitment.finalized));  // => 0
//     print(Commitment.processed.compareTo(Commitment.processed));  // => 0
//     print(Commitment.processed.compareTo(Commitment.confirmed));  // => -1
//     print(Commitment.processed.compareTo(Commitment.finalized));  // => -2
//   });
// }