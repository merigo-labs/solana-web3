/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/src/config/commitment.dart';
import 'package:solana_web3/src/public_key.dart';
import 'package:solana_web3/src/rpc/rpc_request_config.dart';
import 'package:solana_web3/src/rpc_config/commitment_config.dart';


/// Get Leader Schedule Config
/// ------------------------------------------------------------------------------------------------

class GetLeaderScheduleConfig extends CommitmentConfig {

  /// JSON-RPC configurations for `getLeaderSchedule` methods.
  const GetLeaderScheduleConfig({
    super.id,
    super.headers,
    super.timeout,
    super.commitment,
    this.identity,
  });

  /// If set, only return results for this validator identity.
  final PublicKey? identity;

  @override
  Map<String, dynamic> object() => {
    'commitment': commitment?.name,
    'identity': identity?.toBase58(),
  };
}