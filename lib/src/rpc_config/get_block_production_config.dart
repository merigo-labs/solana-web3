/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/src/config/commitment.dart';
import 'package:solana_web3/src/models/slot_range.dart';
import 'package:solana_web3/src/public_key.dart';
import 'package:solana_web3/src/rpc/rpc_request_config.dart';


/// Get Block Production Config
/// ------------------------------------------------------------------------------------------------

class GetBlockProductionConfig extends RpcRequestConfig {

  /// JSON-RPC configurations for `getBlockProduction` methods.
  const GetBlockProductionConfig({
    super.id,
    super.headers,
    super.timeout,
    this.commitment,
    this.range,
    this.identity,
  });

  /// The type of block to query for the request (default: [Commitment.finalized]).
  final Commitment? commitment;

  /// The slot range to return block production for. If omitted, it defaults to the current epoch.
  final SlotRange? range;

  /// If set, return results for this validator identity only.
  final PublicKey? identity;

  @override
  Map<String, dynamic> object() => {
    'commitment': commitment?.name,
    'range': range?.toJson(),
    'identity': identity?.toBase58(),
  };
}