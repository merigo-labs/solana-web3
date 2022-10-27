/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/utils/buffer.dart';


/// Shortvec Encoding
/// ------------------------------------------------------------------------------------------------

/// Returns the short-vec encoded length.
int decodeLength(final Buffer buffer) {
  int len = 0;
  int size = 0;
  for (final int byte in buffer) {
    len |= (byte & 0x7f) << (size * 7);
    size += 1;
    if ((byte & 0x80) == 0) {
      break;
    }
  }
  if (size > 0) {
    buffer.set(buffer.getRange(size).toList(growable: false));
  }
  return len;
}

/// Encodes [length] into a byte array.
List<int> encodeLength(final int length) {
  assert(length >= 0);
  final List<int> bytes = [];
  int remainingLength = length;
  for (;;) {
    int elem = remainingLength & 0x7f;
    remainingLength >>= 7;
    if (remainingLength == 0) {
      bytes.add(elem);
      break;
    } else {
      elem |= 0x80;
      bytes.add(elem);
    }
  }
  return bytes;
}