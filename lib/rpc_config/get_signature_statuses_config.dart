/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/rpc/rpc_request_config.dart';


/// Get Signature Statuses Config
/// ------------------------------------------------------------------------------------------------

class GetSignatureStatusesConfig extends RpcRequestConfig {

  /// JSON-RPC configurations for `getLeaderSchedule` methods.
  const GetSignatureStatusesConfig({
    super.id,
    super.headers,
    super.timeout,
    this.searchTransactionHistory = false,
  });

  /// If true, a Solana node will search its ledger cache for any signatures not found in the recent 
  /// status cache.
  final bool searchTransactionHistory;

  @override
  Map<String, dynamic> object() => {
    'searchTransactionHistory': searchTransactionHistory,
  };
}