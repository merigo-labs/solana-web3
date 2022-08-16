/// Imports
/// ------------------------------------------------------------------------------------------------

import 'rpc_request_config.dart';
import '../src/utils/types.dart';
import '../types/commitment.dart';
import '../types/transaction_encoding.dart';


/// Send Transaction Config
/// ------------------------------------------------------------------------------------------------

class SendTransactionConfig extends RpcRequestConfig {

  /// JSON-RPC configurations for `sendTransaction` methods.
  const SendTransactionConfig({
    super.id,
    super.headers,
    super.timeout,
    this.skipPreflight = false,
    this.preflightCommitment,
    this.encoding = TransactionEncoding.base64,
    this.maxRetries,
    this.minContextSlot,
  }): assert(encoding == TransactionEncoding.base64);

  /// If true, skip the preflight transaction checks (default: `false`).
  final bool skipPreflight;

  /// The type of block to query for the request (default: [Commitment.finalized]).
  final Commitment? preflightCommitment;

  /// The transaction data encoding (must be 'base64').
  final TransactionEncoding encoding;

  /// The maximum number of times for the RPC node to retry sending the transaction to the leader. 
  /// If this parameter not provided, the RPC node will retry the transaction until it is finalised 
  /// or until the blockhash expires.
  final usize? maxRetries;

  /// The minimum slot that the request can be evaluated at.
  final num? minContextSlot;

  @override
  Map<String, dynamic> object() => {
    'skipPreflight': skipPreflight,
    'preflightCommitment': preflightCommitment?.name,
    'encoding': encoding.name,
    'maxRetries': maxRetries,
    'minContextSlot': minContextSlot,
  };

  /// Creates a copy of `this` instance, applying the provided parameters as default values.
  /// 
  /// ```
  /// final SendTransactionConfig config = SendTransactionConfig(
  ///   preflightCommitment: null,
  /// );
  /// print(config.object());     //  {
  ///                             //    ...,
  ///                             //    'preflightCommitment': null,
  ///                             //  }
  /// 
  /// final SendTransactionConfig configCopy = config.applyDefault(
  ///   preflightCommitment: Commitment.finalized,
  /// );
  /// print(configCopy.object()); //  {
  ///                             //    ...,
  ///                             //    'preflightCommitment': 'finalized',
  ///                             //  }
  /// ```
  SendTransactionConfig applyDefault({
    final Commitment? preflightCommitment,
  }) => SendTransactionConfig(
    id: id,
    headers: headers,
    timeout: timeout,
    skipPreflight: skipPreflight,
    preflightCommitment: preflightCommitment ?? this.preflightCommitment,
    encoding: encoding,
    maxRetries: maxRetries,
    minContextSlot: minContextSlot,
  );
}