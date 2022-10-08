/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:solana_common/utils/buffer.dart';
import 'package:solana_common/utils/library.dart';
import '../src/public_key.dart';
import '../src/transaction/transaction.dart';


/// Memo Program
/// ------------------------------------------------------------------------------------------------

class MemoProgram {

  const MemoProgram._();

  static const maxLength = 566;

  /// The public key that identifies the Memo Program.
  static final PublicKey programId = PublicKey.fromBase58(
    'MemoSq4gqABAXKb96qnH8TysNcWxMyWCqXgDLGmfcHr',
  );

  /// Generates a memo instruction.
  static TransactionInstruction create(
    final String memo, {
    final List<PublicKey> signers = const [],
  }) {
    
    final Uint8List data = Buffer.fromList(utf8.encode(memo)).asUint8List();

    final List<AccountMeta> keys = signers.map(
      (final PublicKey signer) => AccountMeta(signer, isSigner: true, isWritable: false)
    ).toList(growable: false);

    /// A 32-byte public key takes up 44-bytes in length when converted to base58, each 8-bytes are 
    /// represented as 11-bytes.
    check((data.length + keys.length * 44) > maxLength);

    return TransactionInstruction(
      keys: keys,
      programId: MemoProgram.programId,
      data: data,
    );
  }
}