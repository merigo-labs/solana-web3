/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/models/serializable.dart';
import 'package:solana_common/utils/types.dart' show u64;
import '../rpc_models/account_info.dart';


/// Transaction Status
/// ------------------------------------------------------------------------------------------------

class TransactionStatus extends Serializable {
  
  /// Transaction status.
  const TransactionStatus({
    required this.err,
    required this.logs,
    required this.accounts,
    required this.unitsConsumed,
  });

  /// The error if transaction failed, null if transaction succeeded.
  /// 
  /// TODO: check error definitions.
  final dynamic err;

  /// An array of log messages the transaction instructions output during execution, null if 
  /// simulation failed before the transaction was able to execute (for example due to an invalid 
  /// blockhash or signature verification failure).
  final List? logs;

  /// An array of accounts with the same length as the accounts.addresses array in the request.
  final List<AccountInfo?>? accounts;

  /// The number of compute budget units consumed during the processing of this transaction.
  final u64? unitsConsumed;

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// TransactionStatus.fromJson({ '<parameter>': <value> });
  /// ```
  factory TransactionStatus.fromJson(final Map<String, dynamic> json) => TransactionStatus(
    err: json['err'],
    logs: json['logs'],
    accounts: json['accounts'],
    unitsConsumed: json['unitsConsumed'],
  );

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// Returns `null` if [json] is omitted.
  /// 
  /// ```
  /// TransactionStatus.tryFromJson({ '<parameter>': <value> });
  /// ```
  static TransactionStatus? tryFromJson(final Map<String, dynamic>? json) {
    return json != null ? TransactionStatus.fromJson(json) : null;
  }

  @override
  Map<String, dynamic> toJson() => {
    'err': err,
    'logs': logs,
    'accounts': accounts,
    'unitsConsumed': unitsConsumed,
  };
}