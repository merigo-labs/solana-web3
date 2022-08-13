/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/config/commitment.dart';
import 'package:solana_web3/config/transaction_encoding.dart';
import 'package:solana_web3/rpc/rpc_request_config.dart';


/// Get Transaction Config
/// ------------------------------------------------------------------------------------------------

class GetTransactionConfig extends RpcRequestConfig {

  /// JSON-RPC configurations for `getTransaction` methods.
  GetTransactionConfig({
    super.id,
    super.headers,
    super.timeout,
    this.encoding = TransactionEncoding.base64,
    this.commitment,
    this.maxSupportedTransactionVersion,
  }): assert(commitment != Commitment.processed),
      assert(encoding == null || encoding.isTransaction),
      assert(maxSupportedTransactionVersion == null || maxSupportedTransactionVersion >= 0);

  /// The transaction data's encoding (default: [TransactionEncoding.json]).
  final TransactionEncoding? encoding;

  /// The type of block to query for the request (default: [Commitment.finalized]).
  final Commitment? commitment;

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