/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/models/serializable.dart';
import 'package:solana_common/utils/convert.dart' show list;
import 'package:solana_common/utils/types.dart' show u64;
import '../src/public_key.dart';
import '../rpc_config/get_supply_config.dart';


/// Supply
/// ------------------------------------------------------------------------------------------------

class Supply extends Serializable {
  
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
  
  /// {@macro solana_common.Serializable.fromJson}
  factory Supply.fromJson(final Map<String, dynamic> json) => Supply(
    total: json['total'],
    circulating: json['circulating'],
    nonCirculating: json['nonCirculating'],
    nonCirculatingAccounts: list.decode(json['nonCirculatingAccounts'], PublicKey.fromBase58),
  );

  /// {@macro solana_common.Serializable.tryFromJson}
  static Supply? tryFromJson(final Map<String, dynamic>? json)
    => json != null ? Supply.fromJson(json) : null;

  @override
  Map<String, dynamic> toJson() => {
    'total': total,
    'circulating': circulating,
    'nonCirculating': nonCirculating,
    'nonCirculatingAccounts': list.encode(nonCirculatingAccounts),
  };
}