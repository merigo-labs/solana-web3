/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/src/config/commitment.dart';
import 'package:solana_web3/src/config/transaction_encoding.dart';
import 'package:solana_web3/src/rpc/rpc_request_config.dart';
import 'package:solana_web3/src/rpc_config/confirm_transaction_config.dart';
import 'package:solana_web3/src/rpc_config/send_transaction_config.dart';
import 'package:solana_web3/src/utils/types.dart';


/// Send And Confirm Transaction Config
/// ------------------------------------------------------------------------------------------------

class SendAndConfirmTransactionConfig extends RpcRequestConfig {

  /// JSON-RPC configurations for `sendAndConfirmTransaction` methods.
  const SendAndConfirmTransactionConfig({
    super.id,
    super.headers,
    super.timeout,
    this.skipPreflight = false,
    this.preflightCommitment,
    this.commitment,
    this.encoding = TransactionEncoding.base64,
    this.maxRetries,
    this.minContextSlot,
  }): assert(encoding == TransactionEncoding.base64);

  /// If true, skip the preflight transaction checks (default: `false`).
  final bool skipPreflight;

  /// The type of block to query for the request (default: [commitment]).
  final Commitment? preflightCommitment;

  /// The type of block to query for the confirmation (default: [Commitment.finalized]).
  final Commitment? commitment;

  /// The transaction data encoding (must be 'base64').
  final TransactionEncoding encoding;

  /// The maximum number of times for the RPC node to retry sending the transaction to the leader. 
  /// If this parameter not provided, the RPC node will retry the transaction until it is finalised 
  /// or until the blockhash expires.
  final usize? maxRetries;

  /// The minimum slot that the request can be evaluated at.
  final num? minContextSlot;

  SendTransactionConfig? toSendTransactionConfig() {
    return SendTransactionConfig(
      id: id,
      headers: headers,
      timeout: timeout, 
      skipPreflight: skipPreflight,
      preflightCommitment: preflightCommitment ?? commitment,
      encoding: encoding,
      maxRetries: maxRetries,
      minContextSlot: minContextSlot,
    );
  }

  ConfirmTransactionConfig? toConfirmTransactionConfig() {
    return ConfirmTransactionConfig(
      id: id,
      headers: headers,
      timeout: timeout, 
      commitment: commitment,
    );
  }

  @override
  Map<String, dynamic> object() => {
    'skipPreflight': skipPreflight,
    'commitment': commitment?.name,
    'preflightCommitment': preflightCommitment?.name,
    'encoding': encoding.name,
    'maxRetries': maxRetries,
    'minContextSlot': minContextSlot,
  };
}