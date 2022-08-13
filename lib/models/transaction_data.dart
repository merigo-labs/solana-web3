/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/config/data_encoding.dart';
import 'package:solana_web3/models/data.dart';
import 'package:solana_web3/models/meta.dart';
import 'package:solana_web3/rpc_config/get_block_config.dart';
import 'package:solana_web3/models/serialisable.dart';
import 'package:solana_web3/models/transaction.dart';
import 'package:solana_web3/utils/library.dart' as utils show cast;


/// Transaction Data
/// ------------------------------------------------------------------------------------------------

class TransactionData<T extends Object> extends Serialisable {
  
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

  /// Create an instance of this class from the given [json] object.
  /// 
  /// @param [json]: A map containing the class' constructor parameters.
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

  /// Create an instance of this class from the given [json] object.
  /// 
  /// @param [json]: A map containing the class' constructor parameters.
  factory TransactionData.fromJson(final Map<String, dynamic> json) { 
    return TransactionData(
      transaction: json['transaction'],
      meta: Meta.tryParse(json['meta']),
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