/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/config/commitment.dart';
import 'package:solana_web3/rpc/rpc_request_config.dart';


/// Commitment Config
/// ------------------------------------------------------------------------------------------------

class CommitmentConfig extends RpcRequestConfig {

  /// JSON-RPC configurations for `commitment`.
  const CommitmentConfig({
    super.id,
    super.headers,
    super.timeout,
    this.commitment,
  });

  /// The type of block to query for the request, for most RPC methods, this defaults to 
  /// [Commitment.finalized].
  final Commitment? commitment;

  @override
  Map<String, dynamic> object() => {
    'commitment': commitment?.name,
  };
}