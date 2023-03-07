/// Imports
/// ------------------------------------------------------------------------------------------------

import 'get_account_info_config.dart';


/// Get Nonce Account Config
/// ------------------------------------------------------------------------------------------------

class GetNonceAccountConfig extends GetAccountInfoConfig {

  /// JSON-RPC configurations for `getNonceAccount` methods.
  GetNonceAccountConfig({
    super.id,
    super.headers,
    super.timeout,
    super.commitment,
    super.minContextSlot,
  });
}