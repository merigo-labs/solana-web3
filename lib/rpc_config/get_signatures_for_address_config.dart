/// Imports
/// ------------------------------------------------------------------------------------------------

import 'commitment_and_min_context_slot_config.dart';


/// Get Signatures For Address Config
/// ------------------------------------------------------------------------------------------------

class GetSignaturesForAddressConfig extends CommitmentAndMinContextSlotConfig {
  
  /// The signature of a confirmed transaction.
  const GetSignaturesForAddressConfig({
    super.id,
    super.headers,
    super.timeout,
    this.limit,
    this.before,
    this.until,
    super.commitment,
    super.minContextSlot,
  });

  /// The maximum transaction signatures to return (between 1 and 1,000, default: 1,000).
  final int? limit;

  /// Start searching backwards from this transaction signature. If not provided the search starts 
  /// from the top of the highest max confirmed block.
  final String? before;

  /// Search until this transaction signature, if found before limit reached.
  final String? until;
  
  /// {@macro solana_common.Serializable.fromJson}
  factory GetSignaturesForAddressConfig.fromJson(final Map<String, dynamic> json) 
    => GetSignaturesForAddressConfig(
      limit: json['limit'],
      before: json['before'],
      until: json['until'],
      commitment: json['commitment'],
      minContextSlot: json['minContextSlot'],
    );

  /// {@macro solana_common.Serializable.tryFromJson}
  static GetSignaturesForAddressConfig? tryFromJson(final Map<String, dynamic>? json) {
    return json != null ? GetSignaturesForAddressConfig.fromJson(json) : null;
  }

  @override
  Map<String, dynamic> object() => {
    'limit': limit,
    'before': before,
    'until': until,
    'commitment': commitment?.name,
    'minContextSlot': minContextSlot,
  };
}
