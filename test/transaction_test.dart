/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solana_web3/programs/index.dart';
import 'package:solana_web3/solana_web3.dart' as web3;


/// Transaction Tests
/// ------------------------------------------------------------------------------------------------

void main() {
  
  WidgetsFlutterBinding.ensureInitialized();

  /// Cluster connections.
  final cluster = web3.Cluster.testnet;
  final connection = web3.Connection(cluster);

  test('error', () async {
    try {
      final sender = web3.Keypair.generateSync();
      final receiver = web3.Keypair.generateSync();
      final tx = web3.Transaction()
        ..add(
          SystemProgram.transfer(
            fromPublicKey: sender.publicKey, 
            toPublicKey: receiver.publicKey, 
            lamports: web3.solToLamports(1),
          )
        );

      final sig = await connection.sendTransaction(tx, signers: [sender]);
      final t = await connection.getTransaction(sig);
    } catch (error) {
      print('TX ERROR $error');
    }
  });
}