/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/config/commitment.dart';
import 'package:solana_web3/rpc_config/commitment_config.dart';


/// Get Fee For Message Config
/// ------------------------------------------------------------------------------------------------

class GetFeeForMessageConfig extends CommitmentConfig {

  /// JSON-RPC configurations for `getFeeForMessage` methods.
  const GetFeeForMessageConfig({
    super.id,
    super.headers,
    super.timeout,
    super.commitment = Commitment.processed,
  });
}