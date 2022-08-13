/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/src/utils/types.dart';


/// Library Utilities
/// ------------------------------------------------------------------------------------------------

/// Asserts that [condition] is `true`.
/// 
/// Throws an [AssertionError] with the provided [message] if [condition] is `false`.
void require(final bool condition, [final Object? message]) {
  if (!condition) {
    throw AssertionError(message);
  }
}

/// Creates a [Duration] of [milliseconds].
/// 
/// Returns `null` if [milliseconds] is omitted.
Duration? tryParseDuration({ required final int? milliseconds }) {
  return milliseconds != null ? Duration(milliseconds: milliseconds) : null;
}

/// Casts [input] as type T.
/// 
/// Throws an exception if [input] is not of type T.
T cast<T>(final Object input) => input as T;

/// Calls `parse(input)` and returns its result.
/// 
/// Returns `null` if [input] is omitted.
T? tryParse<T, U>(final dynamic input, final RpcParser<T, U> parse) {
  return input != null ? parse(input) : null;
}

/// Calls a [callback] function and returns its value.
/// 
/// Returns `null` if execution fails.
T? tryCall<T>(T Function() callback) {
  try {
    return callback();
  } catch (_) {
    return null;
  }
}