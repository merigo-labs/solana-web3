/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/models/serialisable.dart';


/// RPC Context
/// ------------------------------------------------------------------------------------------------

class RpcContext extends Serialisable {
  
  /// Defines a JSON-RPC (response) context.
  const RpcContext({
    required this.slot,
  });

  /// The slot at which the operation was evaluated.
  final int slot;

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// RpcContext.fromJson({ '<parameter>': <value> });
  /// ```
  factory RpcContext.fromJson(final Map<String, dynamic> json) {
    return RpcContext(slot: json['slot']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'slot': slot,
    };
  }
}