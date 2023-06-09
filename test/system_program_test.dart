// /// Imports
// /// ------------------------------------------------------------------------------------------------

// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:solana_jsonrpc/jsonrpc.dart';
// import 'package:solana_web3/src/crypto/keypair.dart';
// import 'package:solana_web3/src/crypto/pubkey.dart';
// import 'package:solana_web3/src/encodings/lamports.dart';
// import 'package:solana_web3/src/programs/system/program.dart';
// import 'package:solana_web3/src/rpc/connection.dart';
// import 'package:solana_web3/src/transactions/transaction.dart';
// import 'utils.dart';


// /// System Program Tests
// /// ------------------------------------------------------------------------------------------------

// void main() {
  
//   WidgetsFlutterBinding.ensureInitialized();

//   /// Cluster connections.
//   final cluster = Cluster.devnet;
//   final connection = Connection(cluster);
  
//   test('With Seed', () async {
//     const String seed = "rust-string";
//     final Keypair programId1 = Keypair.generateSync();
//     final Keypair programId2 = Keypair.generateSync();
//     final Keypair programId3 = Keypair.generateSync();
//     final Pubkey newAccountPubkey = Pubkey.createWithSeed(
//       wallet.pubkey,
//       seed, 
//       programId1.pubkey,
//     );
//     final Pubkey transferWithSeedAddress = Pubkey.createWithSeed(
//       wallet.pubkey,
//       seed,
//       programId2.pubkey,
//     );
//     final Pubkey toPubkey = Pubkey.createWithSeed(
//       wallet.pubkey,
//       seed,
//       programId3.pubkey,
//     );
//     final Transaction tx = Transaction(
//       instructions: [
//         SystemProgram.allocateWithSeed(
//           accountPubkey: toPubkey, 
//           basePubkey: wallet.pubkey, 
//           seed: seed, 
//           space: BigInt.from(10),
//           programId: programId3.pubkey,
//         ),
//         SystemProgram.assignWithSeed(
//           accountPubkey: toPubkey, 
//           basePubkey: wallet.pubkey, 
//           seed: seed, 
//           programId: programId3.pubkey,
//         ),
//         SystemProgram.transferWithSeed(
//           fromPubkey: transferWithSeedAddress,
//           basePubkey: wallet.pubkey, 
//           toPubkey: toPubkey,
//           lamports: solToLamports(lamportsPerSol * 0.05),
//           seed: seed, 
//           programId: programId2.pubkey,
//         ),
//         SystemProgram.createAccountWithSeed(
//           fromPubkey: wallet.pubkey,
//           basePubkey: wallet.pubkey, 
//           newAccountPubkey: newAccountPubkey, 
//           lamports: solToLamports(0.05), 
//           seed: seed, 
//           space: BigInt.from(10),
//           programId: programId1.pubkey,
//         ),
//       ],
//     );
//     try {
//       await connection.requestAirdropAndConfirmTransaction(transferWithSeedAddress, solToLamports(2).toInt());
//       await connection.requestAirdropAndConfirmTransaction(wallet.pubkey, solToLamports(2).toInt());
//       await connection.sendAndConfirmTransaction(tx, signers: [wallet]);
//     } on JsonRpcException catch(e) {
//       print('CODE  ${e.code}');
//       print('ERROR ${e.message}');
//       print('DATA  ${e.data}');
//     }
//   });
// }
