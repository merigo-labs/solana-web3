/// Imports
/// ------------------------------------------------------------------------------------------------

import 'commitment_config.dart';
import '../types/account_filter.dart';


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
}