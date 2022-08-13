/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/models/serialisable.dart';
import 'package:solana_web3/rpc/rpc_context.dart';
import 'package:solana_web3/utils/library.dart' as utils show tryParse;
import 'package:solana_web3/utils/types.dart' show RpcParser;


/// RPC Context Result
/// ------------------------------------------------------------------------------------------------

class RpcContextResult<T> extends Serialisable {
  
  /// Defines a common JSON-RPC `success` result.
  const RpcContextResult({
    required this.context,
    required this.value,
  });

  /// A JSON-RPC response context.
  final RpcContext context;

  /// The value returned by the operation.
  final T? value;

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// [RpcContextResult.value] is set to the return value of `parse(json['value'])`.
  /// 
  /// ```
  /// RpcContextResult.parse({ '<parameter>': <value> }, (U) => T);
  /// ```
  static RpcContextResult<T> parse<T, U>(
    final Map<String, dynamic> json, 
    final RpcParser<T, U> parse,
  ) {
    const String valueKey = 'value';
    json[valueKey] = utils.tryParse(json[valueKey], parse);
    return RpcContextResult<T>.fromJson(json);
  }

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// [RpcContextResult.value] is set to the return value of `parse(json['value'])`.
  /// 
  /// Returns `null` if [json] is omitted.
  /// 
  /// ```
  /// RpcContextResult.tryParse({ '<parameter>': <value> }, (U) => T);
  /// ```
  static RpcContextResult<T>? tryParse<T, U> (
    final Map<String, dynamic>? json, 
    final RpcParser<T, U> parse,
  ) {
    return json != null ? RpcContextResult.parse(json, parse) : null;
  }

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// RpcContextResult.fromJson({ '<parameter>': <value> });
  /// ```
  factory RpcContextResult.fromJson(final Map<String, dynamic> json) => RpcContextResult(
    context: RpcContext.fromJson(json['context']), 
    value: json['value'],
  );

  @override
  Map<String, dynamic> toJson() {
    return {
      'context': context.toJson(),
      'value': value,
    };
  }
}