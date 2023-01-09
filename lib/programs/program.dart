/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/utils/buffer.dart';
import 'package:solana_web3/exceptions/index.dart';
import '../rpc_models/account_info.dart';
import '../src/connection.dart';
import '../src/models/program_address.dart';
import '../src/public_key.dart';
import '../src/transaction/transaction.dart';


/// Program
/// ------------------------------------------------------------------------------------------------

abstract class Program {

  /// Solana program.
  const Program(this.publicKey);

  /// The public key that identifies this program (i.e. program id).
  final PublicKey publicKey;

  /// Finds a valid program address for the given [seeds].
  ///
  /// `Valid program addresses must fall off the ed25519 curve.` This function iterates a nonce 
  /// until it finds one that can be combined with the seeds to produce a valid program address.
  /// 
  /// Throws an [AssertionError] if [seeds] contains an invalid seed.
  /// 
  /// Throws a [PublicKeyException] if a valid program address could not be found.
  ProgramAddress findProgramAddress(final List<List<int>> seeds)
    => PublicKey.findProgramAddress(seeds, publicKey);

  /// Check that the program has been deployed to the cluster and is an executable program.
  /// 
  /// Throws a [ProgramException] if [publicKey] does not refer to a valid program.
  Future<void> checkDeployed(final Connection connection) async {
    final AccountInfo? programInfo = await connection.getAccountInfo(publicKey);
    if (programInfo == null) {
      throw ProgramException('The program $runtimeType ($publicKey) has not been deployed.');
    } else if (!programInfo.executable) {
      throw ProgramException('The program $runtimeType ($publicKey) is not executable.');
    }
  }
  
  /// Creates a [TransactionInstruction] for the program [instruction].
  TransactionInstruction createTransactionIntruction(
    final Enum instruction, {
    required final List<AccountMeta> keys,
    final List<Iterable<int>> data = const [],
  }) {
    return TransactionInstruction(
      keys: keys, 
      programId: publicKey,
      data: Buffer.flatten([Buffer.fromUint8(instruction.index), ...data]).asUint8List(),
    );
  }
}