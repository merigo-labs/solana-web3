/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:convert' show base64;
import 'package:solana_common/borsh/borsh.dart';
import 'package:solana_web3/programs/index.dart';
import 'package:solana_web3/rpc_models/index.dart';
import 'fee_calculator.dart';
import 'public_key.dart';
import 'transaction/transaction.dart';


/// Nonce Account
/// ------------------------------------------------------------------------------------------------

class NonceAccount extends BorshSerializable {

  /// https://docs.solana.com/offline-signing/durable-nonce
  /// 
  /// Durable transaction nonces are a mechanism for getting around the typical short lifetime of a 
  /// transaction's recent_blockhash.
  /// 
  /// Each transaction submitted on Solana must specify a recent blockhash that was generated within 
  /// 2 minutes of the latest blockhash. If it takes longer than 2 minutes to get everybody’s 
  /// signatures, then you have to use nonce accounts.
  /// 
  /// For example, nonce accounts are used in cases when you need multiple people to sign a 
  /// transaction, but they can’t all be available to sign it on the same computer within a short 
  /// enough time period.
  const NonceAccount({
    required this.version,
    required this.state,
    required this.authorizedPubkey,
    required this.nonce,
    required this.feeCalculator,
  });

  /// Version.
  final int version;

  /// Account state.
  final int state;

  /// The authority of the nonce account.
  final PublicKey authorizedPubkey;
  
  /// Durable nonce (32 byte base-58 encoded string).
  final String nonce;

  /// Transaction fee calculator.
  final FeeCalculator feeCalculator;

  @override
  BorshSchema get schema => codec.schema;
  
  /// Nonce account layout byte length.
  static int get length => codec.byteLength;

  /// {@macro solana_common.BorshSerializable.codec}
  static BorshStructSizedCodec get codec {
    return borsh.structSized({
      'version': borsh.u32,
      'state': borsh.u32,
      'authorizedPubkey': borsh.publicKey,
      'nonce': borsh.base58(32),
      'feeCalculator': FeeCalculator.codec,
    });
  }
  /// {@macro solana_common.Serializable.fromJson}
  factory NonceAccount.fromJson(final Map<String, dynamic> json) => NonceAccount(
    version: json['version'],
    state: json['state'],
    authorizedPubkey: PublicKey.fromBase58(json['authorizedPubkey']),
    nonce: json['nonce'],
    feeCalculator: FeeCalculator.fromJson(json['feeCalculator']),
  );

  /// {@macro solana_common.BorshSerializable.deserialize}
  static NonceAccount deserialize(final Iterable<int> buffer) {
    return borsh.deserialize(codec.schema, buffer, NonceAccount.fromJson);
  }

  /// {@macro solana_common.BorshSerializable.tryDeserialize}
  static NonceAccount? tryDeserialize(final Iterable<int>? buffer)
    => buffer != null ? NonceAccount.deserialize(buffer) : null;

  /// {@macro solana_common.BorshSerializable.fromBase64}
  static NonceAccount fromBase64(final String encoded) 
    => NonceAccount.deserialize(base64.decode(encoded));

  /// {@macro solana_common.BorshSerializable.tryFromBase64}
  static NonceAccount? tryFromBase64(final String? encoded)
    => encoded != null ? NonceAccount.fromBase64(encoded) : null;

  /// Creates an instance of `this` class from an account [info].
  /// 
  /// ```
  /// NonceAccount.fromAccountInfo('AA==');
  /// ```
  factory NonceAccount.fromAccountInfo(final AccountInfo info) {
    return info.isBinary 
      ? NonceAccount.fromBase64(info.binaryData[0]) 
      : NonceAccount.fromJson(info.jsonData);
  }

  /// Creates an instance of `this` class from an account [info].
  /// 
  /// Returns `null` if [info] is omitted.
  /// 
  /// ```
  /// NonceAccount.tryFromAccountInfo('AA==');
  /// ```
  static NonceAccount? tryFromAccountInfo(final AccountInfo? info)
    => info != null ? NonceAccount.fromAccountInfo(info) : null;
  
  @override
  Map<String, dynamic> toJson() => {
    'version': version,
    'state': state,
    'authorizedPubkey': authorizedPubkey.toBase58(),
    'nonce': nonce,
    'feeCalculator': feeCalculator.toJson(),
  };

  /// Creates a [NonceInformation] instance from the nonce account data.
  NonceInformation toNonceInformation(final PublicKey nonceAccount) => NonceInformation(
    nonce: nonce, 
    nonceInstruction: SystemProgram.nonceAdvance(
      noncePublicKey: nonceAccount, 
      authorizedPublicKey: authorizedPubkey,
    ),
  );
}