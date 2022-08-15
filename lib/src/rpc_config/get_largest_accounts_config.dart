/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/src/config/account_filter.dart';
import 'package:solana_web3/src/config/commitment.dart';
import 'package:solana_web3/src/rpc_config/commitment_config.dart';


/// Get Largest Accounts Config
/// ------------------------------------------------------------------------------------------------

class GetLargestAccountsConfig extends CommitmentConfig {

  /// JSON-RPC configurations for `getLargeAccounts` methods.
  const GetLargestAccountsConfig({
    super.id,
    super.headers,
    super.timeout,
    super.commitment,
    this.filter,
  });

  /// Filter results by account type.
  final AccountFilter? filter;

  @override
  Map<String, dynamic> object() => {
    'commitment': commitment?.name,
    'filter': filter?.name,
  };

  /// Creates a copy of `this` instance, applying the provided parameters as default values.
  /// 
  /// ```
  /// const GetLargestAccountsConfig config = GetLargestAccountsConfig(
  ///   commitment: null,
  ///   filter: AccountFilter.circulating,
  /// );
  /// print(config.object());     //  {
  ///                             //    'commitment': null,
  ///                             //    'filter': 'circulating',
  ///                             //  }
  /// 
  /// final GetLargestAccountsConfig configCopy = config.applyDefault(
  ///   commitment: Commitment.finalized,
  ///   filter: AccountFilter.nonCirculating, // ignored
  /// );
  /// print(configCopy.object()); //  {
  ///                             //    'commitment': 'finalized',
  ///                             //    'filter': 'circulating',
  ///                             //  }
  /// ```
  GetLargestAccountsConfig applyDefault({
    final Commitment? commitment,
    final AccountFilter? filter,
  }) => GetLargestAccountsConfig(
    id: id,
    headers: headers,
    timeout: timeout,
    commitment: this.commitment ?? commitment,
    filter: this.filter ?? filter,
  );
}