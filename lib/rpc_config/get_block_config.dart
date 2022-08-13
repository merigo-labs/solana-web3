/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/config/transaction_detail.dart';
import 'package:solana_web3/config/commitment.dart';
import 'package:solana_web3/config/transaction_encoding.dart';
import 'package:solana_web3/rpc/rpc_request_config.dart';
import 'package:solana_web3/utils/types.dart' show u64;


/// Get Block Config
/// ------------------------------------------------------------------------------------------------

class GetBlockConfig extends RpcRequestConfig {

  /// JSON-RPC configurations for `getBlock` methods.
  GetBlockConfig({
    super.id,
    super.headers,
    super.timeout,
    this.encoding,
    this.transactionDetails,
    this.rewards,
    this.commitment,
    this.maxSupportedTransactionVersion,
  }): assert(commitment != Commitment.processed),
      assert(encoding == null || encoding.isTransaction),
      assert(maxSupportedTransactionVersion == null || maxSupportedTransactionVersion >= 0);

  /// The encoding for each returned transaction (default: [TransactionEncoding.json]).
  final TransactionEncoding? encoding;

  /// The level of transaction details to return (default: [TransactionDetail.full]).
  final TransactionDetail? transactionDetails;

  /// If true, populate the response's rewards array (default: `true`).
  final bool? rewards;

  /// The type of block to query for the request, [Commitment.processed] is not supported 
  /// (default: [Commitment.finalized]).
  final Commitment? commitment;

  /// The max transaction version to return in responses. If the requested block contains a 
  /// transaction with a higher version, an error will be returned.
  final u64? maxSupportedTransactionVersion;

  @override
  Map<String, dynamic> object() => {
    'encoding': encoding?.name,
    'transactionDetails': transactionDetails?.name,
    'rewards': rewards,
    'commitment': commitment?.name,
    'maxSupportedTransactionVersion': maxSupportedTransactionVersion,
  };
}