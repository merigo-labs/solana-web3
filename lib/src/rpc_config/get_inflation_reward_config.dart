/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/src/config/commitment.dart';
import 'package:solana_web3/src/rpc/rpc_request_config.dart';
import 'package:solana_web3/src/utils/types.dart' show u64;


/// Get Inflation Reward Config
/// ------------------------------------------------------------------------------------------------

class GetInflationRewardConfig extends RpcRequestConfig {

  /// JSON-RPC configurations for `getInflationReward` methods.
  const GetInflationRewardConfig({
    super.id,
    super.headers,
    super.timeout,
    this.commitment,
    this.epoch,
    this.minContextSlot,
  }): assert(minContextSlot == null || minContextSlot >= 0);

  /// The type of block to query for the request (default: [Commitment.finalized]).
  final Commitment? commitment;

  /// The epoch for which the reward occurs. If omitted, the previous epoch will be used.
  final u64? epoch;

  /// The minimum slot that the request can be evaluated at.
  final u64? minContextSlot;
  
  @override
  Map<String, dynamic> object() => {
    'commitment': commitment?.name,
    'epoch': epoch,
    'minContextSlot': minContextSlot,
  };
}