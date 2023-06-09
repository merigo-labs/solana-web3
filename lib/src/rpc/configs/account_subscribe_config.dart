/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_jsonrpc/jsonrpc.dart' show CommitmentConfig;
import '../../encodings/account_encoding.dart';


/// Account Subscribe Config
/// ------------------------------------------------------------------------------------------------

class AccountSubscribeConfig extends CommitmentConfig {

  /// Creates a config object for JSON RPC `accountSubscribe` requests.
  const AccountSubscribeConfig({
    super.commitment,
    this.encoding = AccountEncoding.base64,
  });

  /// The account data's encoding (default: [AccountEncoding.base64]).
  final AccountEncoding encoding;
}