/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/src/config/commitment.dart';
import 'package:solana_web3/src/rpc/rpc_request_config.dart';
import 'package:solana_web3/src/utils/types.dart' show u64;


/// Get Signatures For Address Config
/// ------------------------------------------------------------------------------------------------

class GetSignaturesForAddressConfig extends RpcRequestConfig {
  
  /// The signature of a confirmed transaction.
  const GetSignaturesForAddressConfig({
    super.id,
    super.headers,
    super.timeout,
    this.limit,
    this.before,
    this.until,
    this.commitment,
    this.minContextSlot,
  });

  /// The maximum transaction signatures to return (between 1 and 1,000, default: 1,000).
  final int? limit;

  /// Start searching backwards from this transaction signature. If not provided the search starts 
  /// from the top of the highest max confirmed block.
  final String? before;

  /// Search until this transaction signature, if found before limit reached.
  final String? until;
  
  /// The type of block to query for the request (default: [Commitment.finalized]).
  final Commitment? commitment;
  
  /// The minimum slot that the request can be evaluated at.
  final u64? minContextSlot;

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// GetSignaturesForAddressConfig.fromJson({ '<parameter>': <value> });
  /// ```
  factory GetSignaturesForAddressConfig.fromJson(final Map<String, dynamic> json) 
    => GetSignaturesForAddressConfig(
      limit: json['limit'],
      before: json['before'],
      until: json['until'],
      commitment: json['commitment'],
      minContextSlot: json['minContextSlot'],
    );

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// Returns `null` if [json] is omitted.
  /// 
  /// ```
  /// GetSignaturesForAddressConfig.fromJson({ '<parameter>': <value> });
  /// ```
  static GetSignaturesForAddressConfig? tryFromJson(final Map<String, dynamic>? json) {
    return json != null ? GetSignaturesForAddressConfig.fromJson(json) : null;
  }

  @override
  Map<String, dynamic> object() => {
    'limit': limit,
    'before': before,
    'until': until,
    'commitment': commitment?.name,
    'minContextSlot': minContextSlot,
  };
}
