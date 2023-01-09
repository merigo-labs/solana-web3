/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/models/serializable.dart';
import 'package:solana_common/utils/convert.dart' show list;
import '../rpc_models/vote_account.dart';


/// Vote Account Status
/// ------------------------------------------------------------------------------------------------

class VoteAccountStatus extends Serializable {
  
  /// Current and delinquent vote accounts.
  const VoteAccountStatus({
    required this.current,
    required this.delinquent,
  });

  /// The current vote accounts.
  final List<VoteAccount> current;

  /// The delinquent vote accounts.
  final List<VoteAccount> delinquent;

  /// {@macro solana_common.Serializable.fromJson}
  factory VoteAccountStatus.fromJson(final Map<String, dynamic> json) => VoteAccountStatus(
    current: list.decode(json['current'], VoteAccount.fromJson),
    delinquent: list.decode(json['delinquent'], VoteAccount.fromJson),
  );

  /// {@macro solana_common.Serializable.tryFromJson}
  static VoteAccountStatus? tryFromJson(final Map<String, dynamic>? json) {
    return json != null ? VoteAccountStatus.fromJson(json) : null;
  }

  @override
  Map<String, dynamic> toJson() => {
    'current': list.encode(current),
    'delinquent': list.encode(delinquent),
  };
}