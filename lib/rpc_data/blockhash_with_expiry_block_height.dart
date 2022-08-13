/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/blockhash.dart';
import 'package:solana_web3/models/serialisable.dart';
import 'package:solana_web3/utils/types.dart';


/// Blockhash With Expiry Block Height
/// ------------------------------------------------------------------------------------------------

class BlockhashWithExpiryBlockHeight extends Serialisable {
  
  /// A confirmed transaction block.
  const BlockhashWithExpiryBlockHeight({
    required this.blockhash,
    required this.lastValidBlockHeight,
  });

  /// A unique base-58 encoded hash that identifies a record (block).
  final Blockhash blockhash;

  /// The last block height at which the blockhash will be valid.
  final u64 lastValidBlockHeight;

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// BlockhashWithExpiryBlockHeight.fromJson({ '<parameter>': <value> });
  /// ```
  factory BlockhashWithExpiryBlockHeight.fromJson(final Map<String, dynamic> json) 
    => BlockhashWithExpiryBlockHeight(
        blockhash: json['blockhash'],
        lastValidBlockHeight: json['lastValidBlockHeight'],
      );

  @override
  Map<String, dynamic> toJson() => {
    'blockhash': blockhash,
    'lastValidBlockHeight': lastValidBlockHeight,
  };
}