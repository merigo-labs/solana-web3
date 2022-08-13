/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/config/commitment.dart';
import 'package:solana_web3/models/serialisable.dart';
import 'package:solana_web3/utils/types.dart' show i64, u64, usize;


/// Signature Status
/// ------------------------------------------------------------------------------------------------

class SignatureStatus extends Serialisable {
  
  /// Signature Status.
  const SignatureStatus({
    required this.slot,
    required this.confirmations,
    required this.err,
    required this.confirmationStatus,
  });

  /// The slot the transaction was processed.
  final u64 slot;

  /// The number of blocks since signature confirmation, null if rooted, as well as finalized by a 
  /// supermajority of the cluster.
  final usize? confirmations;

  /// An error if transaction failed, null if transaction succeeded.
  /// 
  /// TODO: Change type to match https://github.com/solana-labs/solana/blob/c0c60386544ec9a9ec7119229f37386d9f070523/sdk/src/transaction/error.rs#L13
  final Map<String, dynamic>? err;
  
  /// The confirmationStatus associated with the transaction, null if no confirmationStatus is present.
  final Commitment? confirmationStatus;
  
  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// SignatureStatus.fromJson({ '<parameter>': <value> });
  /// ```
  factory SignatureStatus.fromJson(final Map<String, dynamic> json) => SignatureStatus(
    slot: json['slot'],
    confirmations: json['confirmations'],
    err: json['err'],
    confirmationStatus: Commitment.tryFromName(json['confirmationStatus']),
  );

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// Returns `null` if [json] is omitted.
  /// 
  /// ```
  /// SignatureStatus.fromJson({ '<parameter>': <value> });
  /// ```
  static SignatureStatus? tryFromJson(final Map<String, dynamic>? json) {
    return json != null ? SignatureStatus.fromJson(json) : null;
  }

  @override
  Map<String, dynamic> toJson() => {
    'slot': slot,
    'confirmations': confirmations,
    'err': err,
    'confirmationStatus': confirmationStatus?.name,
  };
}