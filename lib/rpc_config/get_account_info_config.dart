/// Imports
/// ------------------------------------------------------------------------------------------------

import '../types/account_encoding.dart';
import '../src/models/data_slice.dart';
import 'commitment_and_min_context_slot_config.dart';


/// Get Account Info Config
/// ------------------------------------------------------------------------------------------------

class GetAccountInfoConfig extends CommitmentAndMinContextSlotConfig {

  /// JSON-RPC configurations for `getAccountInfo` methods.
  GetAccountInfoConfig({
    super.id,
    super.headers,
    super.timeout,
    super.commitment,
    this.encoding = AccountEncoding.base64,
    this.dataSlice,
    super.minContextSlot,
  }): assert(encoding.isAccount, 'Invalid encoding.'),
      assert(dataSlice == null || encoding.isBinary, 'Must use binary encoding for [DataSlice].'),
      assert(minContextSlot == null || minContextSlot >= 0);

  /// The account data's encoding (default: [AccountEncoding.base64]). 
  /// 
  /// If [dataSlice] is provided, encoding is limited to `base58`, `base64` or `base64+zstd`.
  final AccountEncoding encoding;

  /// Limit the returned account data to the range [DataSlice.offset] : [DataSlice.offset] + 
  /// [DataSlice.length].
  final DataSlice? dataSlice;

  @override
  Map<String, dynamic> object() => {
    'commitment': commitment?.name,
    'encoding': encoding.name,
    'dataSlice': dataSlice?.toJson(),
    'minContextSlot': minContextSlot,
  };
}