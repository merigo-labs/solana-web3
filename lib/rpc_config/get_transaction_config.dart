/// Imports
/// ------------------------------------------------------------------------------------------------

import 'commitment_config.dart';
import '../types/commitment.dart';
import '../types/transaction_encoding.dart';


/// Get Transaction Config
/// ------------------------------------------------------------------------------------------------

class GetTransactionConfig extends CommitmentConfig {

  /// JSON-RPC configurations for `getTransaction` methods.
  GetTransactionConfig({
    super.id,
    super.headers,
    super.timeout,
    this.encoding = TransactionEncoding.base64,
    super.commitment,
    this.maxSupportedTransactionVersion,
  }): assert(encoding == null || encoding.isTransaction),
      assert(maxSupportedTransactionVersion == null || maxSupportedTransactionVersion >= 0),
      assert(commitment != Commitment.processed, 'The commitment "processed" is not supported.');

  /// The transaction data's encoding (default: [TransactionEncoding.json]).
  final TransactionEncoding? encoding;

  /// The max transaction version to return in responses. If the requested transaction is a higher 
  /// version, an error will be returned. If this parameter is omitted, only legacy transactions 
  /// will be returned, and any versioned transaction will prompt the error.
  final int? maxSupportedTransactionVersion;
  
  @override
  Map<String, dynamic> object() => {
    'encoding': encoding?.name,
    'commitment': commitment?.name,
    'maxSupportedTransactionVersion': maxSupportedTransactionVersion,
  };
}