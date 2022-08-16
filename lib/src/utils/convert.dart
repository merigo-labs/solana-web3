/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:typed_data' show Uint8List;
import 'package:base_codecs/base_codecs.dart' show Base16Codec, Base58CodecBitcoin;
import '../models/serialisable.dart';
import 'list_codec.dart';
import 'types.dart' show RpcParser;


/// Convert
/// ------------------------------------------------------------------------------------------------

/// Base-16 Codec
const hex = Base16Codec();
String hexEncode(final Uint8List input) => hex.encode(input);
Uint8List hexDecode(final String encoded) => hex.decode(encoded);

/// Base-58 Codec
const base58 = Base58CodecBitcoin();
String base58Encode(final Uint8List input) => base58.encode(input);
Uint8List base58Decode(final String encoded) => base58.decode(encoded);

/// Zstd
/// TODO: Implement Zstandard for dart.

/// List Codec
const list = ListCodec();
List<Map<String, dynamic>> listEncode(
  final List<Serialisable> items, { 
  final bool growable = false, 
}) => list.encode(items, growable: growable);
List<T> listDecode<T, U>(
  final Iterable<U> items,
  final RpcParser<T, U> parse, {
  final bool growable = false,
}) => list.decode(items, parse, growable: growable);