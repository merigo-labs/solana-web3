/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/src/models/serialisable.dart';
import 'package:solana_web3/src/public_key.dart';
import 'package:solana_web3/src/rpc_config/get_supply_config.dart';
import 'package:solana_web3/src/utils/convert.dart' show list;
import 'package:solana_web3/src/utils/types.dart' show u64;


/// Supply
/// ------------------------------------------------------------------------------------------------

class Supply extends Serialisable {
  
  /// Information about the current supply.
  const Supply({
    required this.total,
    required this.circulating,
    required this.nonCirculating,
    required this.nonCirculatingAccounts,
  });

  /// The total supply in lamports.
  final u64 total;

  /// The circulating supply in lamports.
  final u64 circulating;

  /// The non-circulating supply in lamports.
  final u64 nonCirculating;
  
  /// An array of account addresses of non-circulating accounts, as strings. If 
  /// [GetSupplyConfig.excludeNonCirculatingAccountsList] is enabled, the returned array will be 
  /// empty.
  final List<PublicKey> nonCirculatingAccounts;
  
  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// Supply.fromJson({ '<parameter>': <value> });
  /// ```
  factory Supply.fromJson(final Map<String, dynamic> json) => Supply(
    total: json['total'],
    circulating: json['circulating'],
    nonCirculating: json['nonCirculating'],
    nonCirculatingAccounts: list.decode(json['nonCirculatingAccounts'], PublicKey.fromString),
  );

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// Returns `null` if [json] is omitted.
  /// 
  /// ```
  /// Supply.fromJson({ '<parameter>': <value> });
  /// ```
  static Supply? tryFromJson(final Map<String, dynamic>? json) {
    return json != null ? Supply.fromJson(json) : null;
  }

  @override
  Map<String, dynamic> toJson() => {
    'total': total,
    'circulating': circulating,
    'nonCirculating': nonCirculating,
    'nonCirculatingAccounts': list.encode(nonCirculatingAccounts),
  };
}