/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/utils/types.dart';
import 'commitment_config.dart';
import 'confirm_transaction_config.dart';
import 'send_transaction_config.dart';
import '../types/commitment.dart';
import '../types/transaction_encoding.dart';


/// Send And Confirm Transaction Config
/// ------------------------------------------------------------------------------------------------

class SendAndConfirmTransactionConfig extends CommitmentConfig {

  /// JSON-RPC configurations for `sendAndConfirmTransaction` methods.
  const SendAndConfirmTransactionConfig({
    super.id,
    super.headers,
    super.timeout,
    this.skipPreflight = false,
    this.preflightCommitment,
    super.commitment,
    this.encoding = TransactionEncoding.base64,
    this.maxRetries,
    this.minContextSlot,
  }): assert(encoding == TransactionEncoding.base64);

  /// If true, skip the preflight transaction checks (default: `false`).
  final bool skipPreflight;

  /// The type of block to query for the request (default: [commitment]).
  final Commitment? preflightCommitment;

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