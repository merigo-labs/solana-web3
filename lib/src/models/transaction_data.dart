/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/exceptions/index.dart';
import 'package:solana_common/models/serializable.dart';
import '../mixins/data_serializable_mixin.dart';
import '../models/meta.dart';
import '../../rpc_config/get_block_config.dart';


/// Transaction Data
/// ------------------------------------------------------------------------------------------------

class TransactionData<T extends Object> extends Serializable with DataSerializableMixin {
  
  /// Confirmed Transaction Block.
  const TransactionData({
    required this.transaction,
    required this.meta,
    required this.version,
  });

  /// Transaction data returned as JSON or binary encoded data.
  final T transaction;

  /// Transaction status metadata.
  final Meta? meta;

  /// Transaction version ('legacy'|number) or `null` if 
  /// [GetBlockConfig.maxSupportedTransactionVersion] was not set in the request params.
  final Object? version;

  /// The transaction data key.
  static const String transactionKey = 'transaction';
  
  @override
  T get rawData => transaction;

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// TransactionData.parse({ '<parameter>': <value> });
  /// ```
  static TransactionData parse(final Map<String, dynamic> json) {
    final Object transaction = DataSerializableMixin.normalize(json[transactionKey]);
    if (transaction is List) {
      return TransactionData<List<String>>.fromJson(json);
    } else if (transaction is Map) {
      return TransactionData<Map<String, dynamic>>.fromJson(json);
    } else {
      throw TransactionException('Unknown data type ${transaction.runtimeType}');
    }
  }

  /// {@macro solana_common.Serializable.fromJson}
  factory TransactionData.fromJson(final Map<String, dynamic> json) { 
    return TransactionData(
      transaction: json[transactionKey],
      meta: Meta.tryFromJson(json['meta']),
      version: json['version'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    transactionKey: transaction,
    'meta': meta,
    'version': version,
  };
}