/// Imports
/// ------------------------------------------------------------------------------------------------

import 'commitment_config.dart';


/// Get Supply Config
/// ------------------------------------------------------------------------------------------------

class GetSupplyConfig extends CommitmentConfig {

  /// JSON-RPC configurations for `getSupply` methods.
  const GetSupplyConfig({
    super.id,
    super.headers,
    super.timeout,
    super.commitment,
    this.excludeNonCirculatingAccountsList,
  });

  /// If true, exclude the list of non circulating accounts from the response.
  final bool? excludeNonCirculatingAccountsList;
  
  @override
  Map<String, dynamic> object() => {
    'commitment': commitment?.name,
    'excludeNonCirculatingAccountsList': excludeNonCirculatingAccountsList,
  };
}