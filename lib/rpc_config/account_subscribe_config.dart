/// Imports
/// ------------------------------------------------------------------------------------------------

import '../types/account_encoding.dart';
import 'commitment_subscribe_config.dart';


/// Account Subscribe Config
/// ------------------------------------------------------------------------------------------------

class AccountSubscribeConfig extends CommitmentSubscribeConfig {

  /// Defines the configurations for JSON-RPC `accountSubscribe` requests.
  AccountSubscribeConfig({
    super.timeout,
    super.commitment,
    this.encoding = AccountEncoding.base64,
  }): assert(encoding.isAccount);

  /// The account data's encoding (default: [AccountEncoding.base64]).
  final AccountEncoding encoding;

  @override
  Map<String, dynamic> object() => {
    'commitment': commitment?.name,
    'encoding': encoding.name,
  };
}