/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/models/serialisable.dart';
import 'package:solana_web3/utils/types.dart' show RpcParser;


/// List Codec
/// ------------------------------------------------------------------------------------------------

class ListCodec {

  /// Converts between `List<Serialisable>` and `List<T>`.
  const ListCodec();

  /// Converts a [Serialisable] list of [items] into a `List<Map<String, dynamic>>`.
  /// 
  /// The [List] has a fixed length if [growable] is `false`.
  List<Map<String, dynamic>> encode(
    final Iterable<Serialisable> items, {
    final bool growable = false,
  }) {
    return items.map((final Serialisable item) => item.toJson()).toList(growable: growable);
  }

  /// Converts a [Serialisable] list of [items] into a `List<Map<String, dynamic>>`.
  /// 
  /// The [List] has a fixed length if [growable] is `false`.
  /// 
  /// Returns `null` if [items] is `null`.
  List<Map<String, dynamic>>? tryEncode(
    final Iterable<Serialisable>? items, {
    final bool growable = false,
  }) {
    return items != null ? encode(items, growable: growable) : null;
  }

  /// Converts a serialised list of [items] into a `List<T>`.
  /// 
  /// The [parse] method converts each item from type `U` into `T`.
  /// 
  /// The [List] has a fixed length if [growable] is `false`.
  List<T> decode<T, U>(
    final Iterable items,
    final RpcParser<T, U> parse, {
    final bool growable = false,
  }) {
    return items.cast<U>().map((final U item) => parse(item)).toList(growable: growable);
  }

  /// Converts a encoded list of [items] into a `List<T>`.
  /// 
  /// The [parse] method converts each item from type `U` into `T`.
  /// 
  /// The [List] has a fixed length if [growable] is `false`.
  /// 
  /// Returns `null` if [items] is `null`.
  List<T>? tryDecode<T, U>(
    final Iterable? items, 
    final RpcParser<T, U> parse, {
    final bool growable = false,
  }) {
    return items != null ? decode<T, U>(items, parse, growable: growable) : null;
  }

  /// Returns a view of the given [value] as a list of [T] instances.
  List<T> cast<T>(final List value) => value.cast<T>();

  /// Returns a view of the given [value] as a list of [T] instances or `null` if [value] is 
  /// omitted.
  List<T>? tryCast<T>(final List? value) => value?.cast<T>();
}