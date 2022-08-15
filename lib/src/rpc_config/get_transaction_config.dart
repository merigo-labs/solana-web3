/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/src/config/commitment.dart';
import 'package:solana_web3/src/config/transaction_encoding.dart';
import 'package:solana_web3/src/rpc/rpc_request_config.dart';
import 'package:solana_web3/src/rpc_config/commitment_config.dart';


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
  }): assert(commitment != Commitment.processed),
      assert(encoding == null || encoding.isTransaction),
      assert(maxSupportedTransactionVersion == null || maxSupportedTransactionVersion >= 0);

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