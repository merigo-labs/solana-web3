/// Imports
/// ------------------------------------------------------------------------------------------------

import 'commitment_config.dart';
import '../types/commitment.dart';


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