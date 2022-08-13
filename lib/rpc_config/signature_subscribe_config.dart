/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/config/commitment.dart';
import 'package:solana_web3/rpc/rpc_subscribe_config.dart';


/// Signature Subscribe Config
/// ------------------------------------------------------------------------------------------------

class SignatureSubscribeConfig extends RpcSubscribeConfig {

  /// JSON-RPC PubSub configurations for `signatureSubscribe` methods.
  SignatureSubscribeConfig({
    super.timeout,
    this.commitment,
  });

  /// The type of block to query for the request.
  final Commitment? commitment;

  @override
  Map<String, dynamic> object() => {
    'commitment': commitment?.name,
  };
}