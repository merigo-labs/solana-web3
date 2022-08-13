/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/src/models/transaction_data.dart';
import 'package:solana_web3/src/utils/types.dart' show i64, u64;


/// Transaction Info
/// ------------------------------------------------------------------------------------------------

class TransactionInfo<T extends Object> extends TransactionData<T> {
  
  /// Confirmed Transaction Block.
  const TransactionInfo({
    required super.transaction,
    required super.meta,
    required super.version,
    required this.slot,
    required this.blockTime,
  });

  /// The slot this transaction was processed in.
  final u64 slot;

  /// The estimated production time, as Unix timestamp (seconds since the Unix epoch) of when the 
  /// transaction was processed - null if not available.
  final i64? blockTime;

  /// Create an instance of this class from the given [json] object.
  /// 
  /// @param [json]: A map containing the class' constructor parameters.
  static TransactionInfo parse(final Map<String, dynamic> json) {
    final TransactionData data = TransactionData.parse(json);
    return TransactionInfo(
      transaction: data.transaction,
      meta: data.meta,
      version: data.version,
      slot: json['slot'],
      blockTime: json['blockTime'],
    );
  }

  static TransactionInfo? tryParse(final Map<String, dynamic>? json) {
    return json != null ? parse(json) : null;
  }

  /// Create an instance of this class from the given [json] object.
  /// 
  /// @param [json]: A map containing the class' constructor parameters.
  static TransactionInfo fromJson(final Map<String, dynamic> json) { 
    final TransactionData data = TransactionData.fromJson(json);
    return TransactionInfo(
      transaction: data.transaction,
      meta: data.meta,
      version: data.version,
      slot: json['slot'],
      blockTime: json['blockTime'],
    );
  }

  @override
  Map<String, dynamic> toJson() => super.toJson()
    ..addAll({
      'slot': slot,
      'blockTime': blockTime,
    });
}