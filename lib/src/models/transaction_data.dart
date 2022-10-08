/// Imports
/// ------------------------------------------------------------------------------------------------

import '../../rpc_config/get_block_config.dart';
import '../../types/data_encoding.dart';
import '../models/data.dart';
import '../models/meta.dart';
import 'package:solana_common/models/serializable.dart';


/// Transaction Data
/// ------------------------------------------------------------------------------------------------

class TransactionData<T extends Object> extends Serializable {
  
  /// Confirmed Transaction Block.
  const TransactionData({
    required this.transaction,
    required this.meta,
    required this.version,
  });

  /// Transaction data returned as JSON or binary encoded data.
  final Data<T> transaction;

  /// Transaction status metadata.
  final Meta? meta;

  /// Transaction version ('legacy'|number) or `null` if 
  /// [GetBlockConfig.maxSupportedTransactionVersion] was not set in the request params.
  final Object? version;

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// TransactionData.parse({ '<parameter>': <value> });
  /// ```
  static TransactionData parse(final Map<String, dynamic> json) {
    const String transactionKey = 'transaction';
    final Data transaction = Data.parse(json[transactionKey]);
    switch (transaction.encoding) {
      case DataEncoding.base58:
      case DataEncoding.base64:
      case DataEncoding.base64Zstd:
        json[transactionKey] = Data.castFrom<String>(transaction);
        return TransactionData<String>.fromJson(json);
      case DataEncoding.json:
      case DataEncoding.jsonParsed:
        json[transactionKey] = Data.castFrom<Map<String, dynamic>>(transaction);
        return TransactionData<Map<String, dynamic>>.fromJson(json);
    }
  }

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// TransactionData.fromJson({ '<parameter>': <value> });
  /// ```
  factory TransactionData.fromJson(final Map<String, dynamic> json) { 
    return TransactionData(
      transaction: json['transaction'],
      meta: Meta.tryFromJson(json['meta']),
      version: json['version'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'transaction': transaction.toJson(),
    'meta': meta,
    'version': version,
  };
}