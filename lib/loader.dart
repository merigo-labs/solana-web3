/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/buffer.dart';
import 'package:solana_web3/buffer_layout.dart' as buffer_layout;
import 'package:solana_web3/config/commitment.dart';
import 'package:solana_web3/connection.dart';
import 'package:solana_web3/keypair.dart';
import 'package:solana_web3/public_key.dart';
import 'package:solana_web3/rpc_config/get_account_info_config.dart';
import 'package:solana_web3/rpc_config/send_and_confirm_transaction_config.dart';
import 'package:solana_web3/rpc_data/account_info.dart';
import 'package:solana_web3/system_program.dart';
import 'package:solana_web3/sysvar.dart';
import 'package:solana_web3/transaction.dart';
import 'package:solana_web3/transaction_constants.dart';
import 'package:solana_web3/utils/types.dart' show u64;


/// Loader
/// ------------------------------------------------------------------------------------------------

class Loader {

  /// Program loader interface.
  const Loader._();

  /// Keep program chunks under `packetDataSize`, leaving enough room for the rest of the 
  /// Transaction fields.
  /// 
  /// TODO: replace 300 with a proper constant for the size of the other Transaction fields.
  /// 
  /// The amount of program data placed in each load Transaction.
  static const int chunkSize = packetDataSize - 300;

  /// Returns the minimum number of signatures required to load a program, not including retries.
  ///
  /// This can be used to calculate transaction fees.
  static int getMinNumSignatures(final int dataLength) {
    return (
      2 *     // Every transaction requires two signatures (payer + program)
      ((dataLength / Loader.chunkSize).ceil() 
        + 1   // Add one for Create transaction
        + 1)  // Add one for Finalise transaction
    );
  }

  /// Loads a generic program.
  /// 
  /// Returns `true` if the [program] was loaded successfully and `false` if the program was already 
  /// loaded.
  /// 
  /// [connection]      The connection to use.
  /// [payer]           the `account` that will pay program loading fees.
  /// [program]         The `account` to load the program into.
  /// [programId]       The public key that identifies the loader.
  /// [data]            The program octets.
  static Future<bool> load(
    Connection connection,
    Signer payer,
    Signer program,
    PublicKey programId,
    Buffer data,
  ) async {
    {
      final u64 balanceNeeded = await connection.getMinimumBalanceForRentExemption(
        data.length,
      );

      // Fetch program account info to check if it has already been created.
      final AccountInfo? programInfo = await connection.getAccountInfo(
        program.publicKey,
        config: GetAccountInfoConfig(commitment: Commitment.confirmed),
      );

      final Transaction transaction = Transaction();

      if (programInfo != null) {
        if (programInfo.executable) {
          print('Program load() failed, the account is already executable.');
          return false;
        }

        if (programInfo.data.length != data.length) {
          transaction.add(
            SystemProgram.allocate(
              accountPublicKey: program.publicKey,
              space: data.length,
            ),
          );
        }

        if (programInfo.owner != programId.toBase58()) {
          transaction.add(
            SystemProgram.assign(
              accountPublicKey: program.publicKey,
              programId: programId,
            ),
          );
        }

        if (programInfo.lamports < balanceNeeded) {
          transaction.add(
            SystemProgram.transfer(
              fromPublicKey: payer.publicKey,
              toPublicKey: program.publicKey,
              lamports: BigInt.from(balanceNeeded - programInfo.lamports),
            ),
          );
        }
      } else {
        transaction.add(
          SystemProgram.createAccount(
            fromPublicKey: payer.publicKey,
            newAccountPublicKey: program.publicKey,
            lamports: balanceNeeded > 0 ? balanceNeeded : 1,
            space: data.length,
            programId: programId,
          ),
        );
      }

      // If the account is already created correctly, skip this step and proceed directly to loading 
      // instructions
      if (transaction.instructions.isNotEmpty) {
        await connection.sendAndConfirmTransaction(
          transaction,
          signers: [payer, program],
          config: SendAndConfirmTransactionConfig(commitment: Commitment.confirmed),
        );
      }
    }

    final buffer_layout.Structure dataLayout = buffer_layout.struct([
      buffer_layout.u32('instruction'),
      buffer_layout.u32('offset'),
      buffer_layout.u32('bytesLength'),
      buffer_layout.u32('bytesLengthPadding'),
      buffer_layout.seq(
        buffer_layout.u8('byte'),
        buffer_layout.offset(buffer_layout.u32(), -8),
        'bytes',
      ),
    ]);

    int offset = 0;
    Buffer buffer = data.slice(0);
    List<Future<String>> transactions = [];
    while (buffer.isNotEmpty) {
      final bytes = buffer.slice(0, chunkSize);
      final data = Buffer(chunkSize + 16);
      dataLayout.encode(
        {
          'instruction': 0, // Load instruction
          'offset': offset,
          'bytes': bytes,
          'bytesLength': 0,
          'bytesLengthPadding': 0,
        },
        data,
      );

      final Transaction transaction = Transaction()..add(
        TransactionInstruction(
          keys: [AccountMeta(program.publicKey, isSigner: true, isWritable: true)], 
          programId: programId,
          data: data.asUint8List(),
        ),
      );

      transactions.add(
        connection.sendAndConfirmTransaction(
          transaction, 
          signers: [payer, program], 
          config: SendAndConfirmTransactionConfig(commitment: Commitment.confirmed),
        ),
      );

      // Delay between sends in an attempt to reduce rate limit errors
      if (connection.cluster.domain.contains('solana.com')) {
        const int requestsPerSecond = 4;
        await Future.delayed(const Duration(seconds: requestsPerSecond));
      }

      offset += chunkSize;
      buffer = buffer.slice(chunkSize);
    }

    await Future.wait(transactions);

    // Finalise the account loaded with program data for execution
    {
      final dataLayout = buffer_layout.struct([
        buffer_layout.u32('instruction'),
      ]);

      final Buffer data = Buffer(dataLayout.span);
      dataLayout.encode(
        {
          'instruction': 1, // Finalise instruction
        },
        data,
      );

      final Transaction transaction = Transaction()..add(
        TransactionInstruction(
          keys: [
            AccountMeta(program.publicKey, isSigner: true, isWritable: true),
            AccountMeta(sysvarRentPublicKey, isSigner: false, isWritable: false),
        ],
        programId: programId,
        data: data.asUint8List(),
        )
      );

      await connection.sendAndConfirmTransaction(
        transaction,
        signers: [payer, program],
        config: SendAndConfirmTransactionConfig(commitment: Commitment.confirmed),
      );
    }

    // success
    return true;
  }
}