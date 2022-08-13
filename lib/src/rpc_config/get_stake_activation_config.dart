/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/src/config/commitment.dart';
import 'package:solana_web3/src/rpc/rpc_request_config.dart';
import 'package:solana_web3/src/utils/types.dart' show u64;


/// Get Stake Activation Config
/// ------------------------------------------------------------------------------------------------

class GetStakeActivationConfig extends RpcRequestConfig {

  /// JSON-RPC configurations for `getStakeActivation` methods.
  const GetStakeActivationConfig({
    super.id,
    super.headers,
    super.timeout,
    this.commitment,
    this.epoch,
    this.minContextSlot,
  }): assert(minContextSlot == null || minContextSlot >= 0);

  /// The type of block to query for the request (default: [Commitment.finalized]).
  final Commitment? commitment;

  /// The epoch for which to calculate activation details. If omitted, defaults to current epoch.
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