/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solana_web3/solana_web3.dart';
import 'package:solana_web3/programs/system.dart';
import 'utils.dart';


/// System Program Tests
/// ------------------------------------------------------------------------------------------------

void main() {
  
  WidgetsFlutterBinding.ensureInitialized();

  /// Cluster connections.
  final cluster = Cluster.devnet;
  final connection = Connection(cluster);
  
  test('With Seed', () async {
    const String seed = "rust-string";
    final Keypair programId1 = Keypair.generateSync();
    final Keypair programId2 = Keypair.generateSync();
    final Keypair programId3 = Keypair.generateSync();
    final PublicKey newAccountPublicKey = PublicKey.createWithSeed(
      wallet.publicKey,
      seed, 
      programId1.publicKey,
    );
    final PublicKey transferWithSeedAddress = PublicKey.createWithSeed(
      wallet.publicKey,
      seed,
      programId2.publicKey,
    );
    final PublicKey toPubkey = PublicKey.createWithSeed(
      wallet.publicKey,
      seed,
      programId3.publicKey,
    );
    final Transaction tx = Transaction(
      instructions: [
        SystemProgram.allocateWithSeed(
          accountPublicKey: toPubkey, 
          basePublicKey: wallet.publicKey, 
          seed: seed, 
          space: BigInt.from(10),
          programId: programId3.publicKey,
        ),
        SystemProgram.assignWithSeed(
          accountPublicKey: toPubkey, 
          basePublicKey: wallet.publicKey, 
          seed: seed, 
          programId: programId3.publicKey,
        ),
        SystemProgram.transferWithSeed(
          fromPublicKey: transferWithSeedAddress,
          basePublicKey: wallet.publicKey, 
          toPublicKey: toPubkey,
          lamports: solToLamports(lamportsPerSol * 0.05),
          seed: seed, 
          programId: programId2.publicKey,
        ),
        SystemProgram.createAccountWithSeed(
          fromPublicKey: wallet.publicKey,
          basePublicKey: wallet.publicKey, 
          newAccountPublicKey: newAccountPublicKey, 
          lamports: solToLamports(0.05), 
          seed: seed, 
          space: BigInt.from(10),
          programId: programId1.publicKey,
        ),
      ],
    );
    try {
      await connection.requestAirdropAndConfirmTransaction(transferWithSeedAddress, solToLamports(2).toInt());
      await connection.requestAirdropAndConfirmTransaction(wallet.publicKey, solToLamports(2).toInt());
      await connection.sendAndConfirmTransaction(tx, signers: [wallet]);
    } on JsonRpcException catch(e) {
      print('CODE  ${e.code}');
      print('ERROR ${e.message}');
      print('DATA  ${e.data}');
    }
  });
}
