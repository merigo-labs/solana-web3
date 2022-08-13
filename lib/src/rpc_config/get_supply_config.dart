/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/src/config/commitment.dart';
import 'package:solana_web3/src/rpc/rpc_request_config.dart';


/// Get Supply Config
/// ------------------------------------------------------------------------------------------------

class GetSupplyConfig extends RpcRequestConfig {

  /// JSON-RPC configurations for `getSupply` methods.
  const GetSupplyConfig({
    super.id,
    super.headers,
    super.timeout,
    this.commitment,
    this.excludeNonCirculatingAccountsList,
  });

  /// The type of block to query for the request (default: [Commitment.finalized]).
  final Commitment? commitment;

  /// If true, exclude the list of non circulating accounts from the response.
  final bool? excludeNonCirculatingAccountsList;
  
  @override
  Map<String, dynamic> object() => {
    'commitment': commitment?.name,
    'excludeNonCirculatingAccountsList': excludeNonCirculatingAccountsList,
  };
}