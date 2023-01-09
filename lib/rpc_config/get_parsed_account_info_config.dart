/// Imports
/// ------------------------------------------------------------------------------------------------

import '../types/account_encoding.dart';
import 'get_account_info_config.dart';


/// Get Parsed Account Info Config
/// ------------------------------------------------------------------------------------------------

class GetParsedAccountInfoConfig extends GetAccountInfoConfig {

  /// JSON-RPC configurations for `getParsedAccountInfo` methods.
  GetParsedAccountInfoConfig({
    super.id,
    super.headers,
    super.timeout,
    super.commitment,
    super.minContextSlot,
  }): super(
        encoding: AccountEncoding.jsonParsed,
      );
}