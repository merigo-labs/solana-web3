/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/utils/utils.dart' as utils show tryCall;


/// Commitments
/// ------------------------------------------------------------------------------------------------

/// The commitment describes how finalised a block is at that point in time. When querying the 
/// ledger state, it's recommended to use lower levels of commitment to report progress and higher 
/// levels to ensure the state will not be rolled back.
/// 
/// For processing many dependent transactions in series, it's recommended to use `confirmed` 
/// commitment, which balances speed with rollback safety. For total safety, it's recommended to 
/// use `finalized` commitment.
/// 
/// The default commitment is `finalized`.
/// 
/// The commitment parameter should be included within the last element in the params array:
/// 
/// ```
/// curl localhost:8899 -X POST -H "Content-Type: application/json" -d '
///   {
///     "jsonrpc": "2.0",
///     "id": 1,
///     "method": "getBalance",
///     "params": [
///       "83astBRguLMdt2h5U1Tpdq5tjFoJ6noeGwaY3mDLVcri",
///       {
///         "commitment": "finalized"
///       }
///     ]
///   }
///   '
/// ```
enum Commitment {

  /*************************************************************************************************
   * KEEP VARIANTS ORDERED BY BLOCK FINALITY (LEAST TO MOST)
  *************************************************************************************************/

  /// The node will query its most recent block. Note that the block may still be skipped by the 
  /// cluster.
  processed,

  /// The node will query the most recent block that has been voted on by supermajority of the 
  /// cluster. It incorporates votes from gossip and replay.
  confirmed,

  /// The node will query the most recent block confirmed by supermajority of the cluster as having 
  /// reached maximum lockout, meaning the cluster has recognised this block as finalised.
  finalized,
  ;

  /// Compares `this` to `other`.
  /// 
  /// Returns a negative number if this is less than other, zero if they are equal, and a positive 
  /// number if this is greater than other.
  /// 
  /// Examples:
  /// ```
  /// print(Commitment.finalized.compareTo(Commitment.processed));  // => 2
  /// print(Commitment.finalized.compareTo(Commitment.confirmed));  // => 1
  /// print(Commitment.finalized.compareTo(Commitment.finalized));  // => 0
  /// print(Commitment.processed.compareTo(Commitment.processed));  // => 0
  /// print(Commitment.processed.compareTo(Commitment.confirmed));  // => -1
  /// print(Commitment.processed.compareTo(Commitment.finalized));  // => -2
  /// ```
  int compareTo(final Commitment? other) => index - (other?.index ?? -1);

  /// Returns the enum variant where [EnumName.name] is equal to [name].
  /// 
  /// Throws an [ArgumentError] if [name] cannot be matched to an existing variant.
  /// 
  /// ```
  /// Commitment.fromName('finalized');
  /// ```
  factory Commitment.fromName(final String name) => values.byName(name);

  /// Returns the enum variant where [EnumName.name] is equal to [name].
  /// 
  /// Returns `null` if [name] cannot be matched to an existing variant.
  /// 
  /// ```
  /// Commitment.tryFromName('finalized');
  /// ```
  static Commitment? tryFromName(final String? name) {
    return name != null ? utils.tryCall(() => Commitment.fromName(name)) : null;
  }
}