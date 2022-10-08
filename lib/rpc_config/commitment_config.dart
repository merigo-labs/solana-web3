/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/protocol/json_rpc_request_config.dart';
import '../types/commitment.dart';


/// Commitment Config
/// ------------------------------------------------------------------------------------------------

class CommitmentConfig extends JsonRpcRequestConfig {

  /// JSON-RPC configurations for `commitment`.
  const CommitmentConfig({
    super.id,
    super.headers,
    super.timeout,
    this.commitment,
  });

  /// The type of block to query for the request. If commitment is not provided, the node will 
  /// default to [Commitment.finalized].
  final Commitment? commitment;

  @override
  Map<String, dynamic> object() => {
    'commitment': commitment?.name,
  };
}