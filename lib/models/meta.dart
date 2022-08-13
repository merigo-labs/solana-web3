/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/config/transaction_error.dart';
import 'package:solana_web3/models/inner_instruction.dart';
import 'package:solana_web3/models/loaded_address.dart';
import 'package:solana_web3/rpc_config/get_block_config.dart';
import 'package:solana_web3/models/serialisable.dart';
import 'package:solana_web3/models/token_balance.dart';
import 'package:solana_web3/utils/convert.dart' as convert show list;
import 'package:solana_web3/utils/types.dart';


/// Meta
/// ------------------------------------------------------------------------------------------------

class Meta extends Serialisable {
  
  /// Transaction status metadata.
  const Meta({
    this.err,
    required this.fee,
    required this.preBalances,
    required this.postBalances,
    this.innerInstructions,
    this.preTokenBalances,
    this.postTokenBalances,
    this.logMessages,
    this.loadedAddresses,
  });

  /// The error if the transaction failed or `null` if it succeeded.
  final TransactionError? err;

  /// The fee this transaction was charged, as a u64 integer.
  final u64 fee;

  /// The account balances before the transaction was processed.
  final List<u64> preBalances;

  /// The account balances after the transaction was processed.
  final List<u64> postBalances;

  /// The cross-program invocation instruction or `null` if inner instruction recording was not 
  /// enabled.
  final List<InnerInstruction>? innerInstructions;

  /// The token balance before the transaction was processed or `null` if token balance recording 
  /// was not enabled during the transaction.
  final List<TokenBalance>? preTokenBalances;

  /// The token balance after the transaction processed or `null` if token balance recording was 
  /// not enabled during the transaction.
  final List<TokenBalance>? postTokenBalances;

  /// The log messages or `null` if log message recording was not enabled during the transaction.
  final List<String>? logMessages;

  /// The transaction addresses loaded from the address lookup tables or `null` if 
  /// [GetBlockConfig.maxSupportedTransactionVersion] was not set in the request params.
  final LoadedAddress? loadedAddresses;

  /// Parse the given [json] object to create an instance of this class or `null`.
  /// 
  /// @param [json]: A map containing the class' parameters.
  static Meta? tryParse(final Map<String, dynamic>? json) {
    return json != null ? Meta.fromJson(json) : null;
  }

  /// Create an instance of this class from the given [json] object.
  /// 
  /// @param [json]: A map containing the class' constructor parameters.
  factory Meta.fromJson(final Map<String, dynamic> json) => Meta(
    err: TransactionError.tryFromName(json['err']),
    fee: json['fee'],
    preBalances: convert.list.cast<int>(json['preBalances']),
    postBalances: convert.list.cast<int>(json['postBalances']),
    innerInstructions: convert.list.tryDecode(json['innerInstructions'], InnerInstruction.fromJson),
    preTokenBalances: convert.list.tryDecode(json['preTokenBalances'], TokenBalance.fromJson),
    postTokenBalances: convert.list.tryDecode(json['postTokenBalances'], TokenBalance.fromJson),
    logMessages: convert.list.tryCast<String>(json['logMessages']),
    loadedAddresses: LoadedAddress.tryFromJson(json['loadedAddresses']),
  );

  @override
  Map<String, dynamic> toJson() => {
    'err': err?.name,
    'fee': fee,
    'preBalances': preBalances,
    'postBalances': postBalances,
    'innerInstructions': convert.list.tryEncode(innerInstructions),
    'preTokenBalances': convert.list.tryEncode(preTokenBalances),
    'postTokenBalances': convert.list.tryEncode(postTokenBalances),
    'logMessages': logMessages,
    'loadedAddresses': loadedAddresses?.toJson(),
  };
}