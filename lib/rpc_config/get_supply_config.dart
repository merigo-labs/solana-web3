/// Imports
/// ------------------------------------------------------------------------------------------------

import 'commitment_config.dart';
import '../types/commitment.dart';


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

  /// Creates a copy of `this` instance, applying the provided parameters as default values.
  /// 
  /// ```
  /// const GetSupplyConfig config = GetSupplyConfig(
  ///   commitment: null,
  ///   excludeNonCirculatingAccountsList: false,
  /// );
  /// print(config.object());     //  {
  ///                             //    'commitment': null,
  ///                             //    'excludeNonCirculatingAccountsList': false,
  ///                             //  }
  /// 
  /// final GetSupplyConfig configCopy = config.applyDefault(
  ///   commitment: Commitment.finalized,
  ///   excludeNonCirculatingAccountsList: true, // ignored
  /// );
  /// print(configCopy.object()); //  {
  ///                             //    'commitment': 'finalized',
  ///                             //    'excludeNonCirculatingAccountsList': false,
  ///                             //  }
  /// ```
  GetSupplyConfig applyDefault({
    final Commitment? commitment,
    final bool? excludeNonCirculatingAccountsList,
  }) => GetSupplyConfig(
    id: id,
    headers: headers,
    timeout: timeout,
    commitment: this.commitment ?? commitment,
    excludeNonCirculatingAccountsList: this.excludeNonCirculatingAccountsList ?? excludeNonCirculatingAccountsList,
  );
}