/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/models/serialisable.dart';
import 'package:solana_web3/utils/convert.dart' as convert;
import 'package:solana_web3/utils/types.dart' show u64;


/// Block Commitment
/// ------------------------------------------------------------------------------------------------

class BlockCommitment extends Serialisable {
  
  /// The block commitment for a particular block.
  const BlockCommitment({
    required this.commitment,
    required this.totalStake,
  });

  /// An array of u64 integers logging the amount of cluster stake in lamports that has voted on the 
  /// block at each depth from 0 to MAX_LOCKOUT_HISTORY + 1.
  final List<u64>? commitment;

  /// The total active stake in lamports of the current epoch.
  final u64 totalStake;

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// BlockCommitment.fromJson({ '<parameter>': <value> });
  /// ```
  factory BlockCommitment.fromJson(final Map<String, dynamic> json) => BlockCommitment(
    commitment: convert.list.tryCast(json['commitment']),
    totalStake: json['totalStake'],
  );

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// Returns `null` if [json] is omitted.
  /// 
  /// ```
  /// BlockCommitment.fromJson({ '<parameter>': <value> });
  /// ```
  static BlockCommitment? tryFromJson(final Map<String, dynamic>? json) {
    return json != null ? BlockCommitment.fromJson(json) : null;
  }

  @override
  Map<String, dynamic> toJson() => {
    'commitment': commitment,
    'totalStake': totalStake,
  };
}