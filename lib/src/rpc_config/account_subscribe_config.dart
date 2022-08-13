/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/src/config/account_encoding.dart';
import 'package:solana_web3/src/config/commitment.dart';
import 'package:solana_web3/src/rpc/rpc_subscribe_config.dart';


/// Account Subscribe Config
/// ------------------------------------------------------------------------------------------------

class AccountSubscribeConfig extends RpcSubscribeConfig {

  /// Defines the configurations for JSON-RPC `accountSubscribe` requests.
  AccountSubscribeConfig({
    super.timeout,
    this.commitment = Commitment.finalized,
    this.encoding = AccountEncoding.base64,
  }): assert(encoding.isAccount);

  /// The type of block to query for the request (default: [Commitment.finalized]).
  final Commitment commitment;

  /// The account data's encoding (default: [AccountEncoding.base64]).
  final AccountEncoding encoding;

  @override
  Map<String, dynamic> object() => {
    'commitment': commitment.name,
    'encoding': encoding.name,
  };
}