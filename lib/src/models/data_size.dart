/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/models/serializable.dart';
import 'package:solana_common/utils/types.dart' show u64;


/// Data Size
/// ------------------------------------------------------------------------------------------------

class DataSize extends Serializable {

  /// Program account filter.
  const DataSize({
    required this.dataSize,
  });

  /// Compares the program account data length with the provided data size.
  final u64 dataSize;

  /// {@macro solana_common.Serializable.fromJson}
  factory DataSize.fromJson(final Map<String, dynamic> json) => DataSize(
    dataSize: json['dataSize'],
  );
  
  /// {@macro solana_common.Serializable.tryFromJson}
  static DataSize? tryFromJson(final Map<String, dynamic>? json)
    => json == null ? null : DataSize.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
    'dataSize': dataSize,
  };
}