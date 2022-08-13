/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/src/config/commitment.dart';
import 'package:solana_web3/src/config/transaction_encoding.dart';
import 'package:solana_web3/src/rpc/rpc_request_config.dart';
import 'package:solana_web3/src/rpc_config/accounts_filter.dart';


/// Simulate Transaction Config
/// ------------------------------------------------------------------------------------------------
 
class SimulateTransactionConfig extends RpcRequestConfig {

  /// JSON-RPC configurations for `SimulateTransaction` methods.
  const SimulateTransactionConfig({
    super.id,
    super.headers,
    super.timeout,
    this.sigVerify = false,
    this.commitment,
    this.encoding = TransactionEncoding.base64,
    this.replaceRecentBlockhash,
    this.accounts,
    this.minContextSlot,
  }): assert(encoding == TransactionEncoding.base64);

  /// If true, the transaction signatures will be verified (default: `false`, conflicts with 
  /// [replaceRecentBlockhash]).
  final bool sigVerify;

  /// The type of block to query for the confirmation (default: [Commitment.finalized]).
  final Commitment? commitment;

  /// The transaction data encoding (must be 'base64').
  final TransactionEncoding encoding;

  /// If true, the transaction recent blockhash will be replaced with the most recent blockhash. 
  /// (default: `false`, conflicts with [sigVerify]).
  final bool? replaceRecentBlockhash;

  /// The maximum number of times for the RPC node to retry sending the transaction to the leader. 
  /// If this parameter not provided, the RPC node will retry the transaction until it is finalised 
  /// or until the blockhash expires.
  final AccountsFilter? accounts;

  /// The minimum slot that the request can be evaluated at.
  final int? minContextSlot;

  @override
  Map<String, dynamic> object() => {
    'sigVerify': sigVerify,
    'commitment': commitment?.name,
    'encoding': encoding.name,
    'replaceRecentBlockhash': replaceRecentBlockhash,
    'accounts': accounts?.toJson(),
    'minContextSlot': minContextSlot,
  };
}