/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/config/account_filter.dart';
import 'package:solana_web3/config/commitment.dart';
import 'package:solana_web3/rpc/rpc_request_config.dart';


/// Get Largest Accounts Config
/// ------------------------------------------------------------------------------------------------

class GetLargestAccountsConfig extends RpcRequestConfig {

  /// JSON-RPC configurations for `getLargeAccounts` methods.
  const GetLargestAccountsConfig({
    super.id,
    super.headers,
    super.timeout,
    this.commitment,
    this.filter,
  });

  /// The type of block to query for the request (default: [Commitment.finalized]).
  final Commitment? commitment;

  /// Filter results by account type.
  final AccountFilter? filter;

  @override
  Map<String, dynamic> object() => {
    'commitment': commitment?.name,
    'filter': filter?.name,
  };
}