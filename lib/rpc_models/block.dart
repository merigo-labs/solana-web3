/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/models/serializable.dart';
import 'package:solana_common/utils/convert.dart' as convert;
import 'package:solana_common/utils/types.dart' show i64, u64;
import '../rpc_config/get_block_config.dart';
import '../src/models/reward.dart';
import '../src/models/transaction_data.dart';
import '../types/transaction_detail.dart';


/// Block
/// ------------------------------------------------------------------------------------------------

class Block extends Serializable {
  
  /// A confirmed transaction block.
  const Block({
    required this.blockhash,
    required this.previousBlockhash,
    required this.parentSlot,
    required this.transactions,
    required this.signatures,
    required this.rewards,
    required this.blockTime,
    required this.blockHeight,
  });

  /// The block's blockhash as a base-58 encoded string.
  final String blockhash;

  /// The parent block's blockhash as a base-58 encoded string or '11111111111111111111111111111111'
  /// if the parent block is not available due to ledger cleanup.
  final String previousBlockhash;

   /// The parent block's slot index.
  final u64 parentSlot;

  /// Transaction details (provided if [TransactionDetail.full] is requested).
  final List<TransactionData>? transactions;

  /// Transaction signatures (provided if [TransactionDetail.signatures] is requested).
  final List<String>? signatures;

  /// Rewards (provided if [GetBlockConfig.rewards] is `true`).
  final List<Reward> rewards;

  /// Estimated block production unix epoch time in seconds or `null` if not available.
  final i64? blockTime;

  /// The number of blocks beneath this block.
  final u64? blockHeight;

  /// Indicates if the parent block ([previousBlockhash]) is available.
  bool get isParentBlockAvailable => previousBlockhash == '11111111111111111111111111111111';

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// Block.fromJson({ '<parameter>': <value> });
  /// ```
  factory Block.fromJson(final Map<String, dynamic> json) => Block(
    blockhash: json['blockhash'],
    previousBlockhash: json['previousBlockhash'],
    parentSlot: json['parentSlot'],
    transactions: convert.list.tryDecode(json['transactions'], TransactionData.parse),
    signatures: convert.list.tryCast<String>(json['signatures']),
    rewards: convert.list.decode(json['rewards'], Reward.fromJson),
    blockTime: json['blockTime'],
    blockHeight: json['blockHeight'],
  );

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// Returns `null` if [json] is omitted.
  /// 
  /// ```
  /// Block.tryFromJson({ '<parameter>': <value> });
  /// ```
  static Block? tryFromJson(final Map<String, dynamic>? json) {
    return json != null ? Block.fromJson(json) : null;
  }

  @override
  Map<String, dynamic> toJson() => {
    'blockhash': blockhash,
    'previousBlockhash': previousBlockhash,
    'parentSlot': parentSlot,
    'transactions': convert.list.tryEncode(transactions),
    'signatures': signatures,
    'rewards': convert.list.encode(rewards),
    'blockTime': blockTime,
    'blockHeight': blockHeight,
  };
}