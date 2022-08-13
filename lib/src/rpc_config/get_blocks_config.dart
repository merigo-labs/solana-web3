/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/src/config/commitment.dart';
import 'package:solana_web3/src/rpc_config/commitment_config.dart';


/// Get Blocks Config
/// ------------------------------------------------------------------------------------------------

class GetBlocksConfig extends CommitmentConfig {

  /// JSON-RPC configurations for `getBlocks` methods.
  const GetBlocksConfig({
    super.id,
    super.headers,
    super.timeout,
    super.commitment,
  }): assert(commitment != Commitment.processed, 'The commitment "processed" is not supported.');
}