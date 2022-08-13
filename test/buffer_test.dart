/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solana_web3/src/buffer.dart';
import './utils.dart';


/// Buffer Tests
/// ------------------------------------------------------------------------------------------------

void main() {

  /// Initialisation
  test('create a zero initialised buffer', () {
    const int length = 16;
    final Buffer buffer = Buffer(length);
    assert(buffer.length == length);
    assert(buffer.every((final int item) => item == 0));
  });
  test('create a buffer from a list', () {
    const List<int> items = [1,2,3,4,5,6,7,8];
    final Buffer buffer = Buffer.fromList(items);
    assert(listEquals(buffer.toList(), items));
  });
  test('create a buffer from a base-58 encoded string', () {
    const String encoded = '3ke2ct1cd4rY7VuvWWKG2'; // 'base-58 encoding'
    const BufferEncoding encoding = BufferEncoding.base58;
    final Buffer expected = Buffer.fromList(
      [98, 97, 115, 101, 53, 56, 32, 101, 110, 99, 111, 100, 105, 110, 103],
    );
    final Buffer buffer = Buffer.fromString(encoded, encoding);
    assert(listEquals(buffer.toList(), expected.toList()));
  });
  test('create a buffer from a base-64 encoded string', () {
    const String encoded = 'YmFzZTY0IGVuY29kaW5n'; // 'base-64 encoding'
    const BufferEncoding encoding = BufferEncoding.base64;
    final Buffer expected = Buffer.fromList(
      [98, 97, 115, 101, 54, 52, 32, 101, 110, 99, 111, 100, 105, 110, 103],
    );
    final Buffer buffer = Buffer.fromString(encoded, encoding);
    assert(listEquals(buffer.toList(), expected.toList()));
  });
  test('create a buffer from a hexadecimal encoded string', () {
    const String encoded = '68657861646563696d616c20656e636f64696e67'; // 'hexadecimal encoding'
    const BufferEncoding encoding = BufferEncoding.hex;
    final Buffer expected = Buffer.fromList(
      [104, 101, 120, 97, 100, 101, 99, 105, 109, 97, 108, 32, 101, 110, 99, 111, 100, 105, 110, 103],
    );
    final Buffer buffer = Buffer.fromString(encoded, encoding);
    assert(listEquals(buffer.toList(), expected.toList()));
  });
  test('create a buffer from a utf-8 encoded string', () {
    const String encoded = '\x75\x74\x66\x2d\x38\x20\x65\x6e\x63\x6f\x64\x69\x6e\x67'; // 'utf-8 encoding'
    const BufferEncoding encoding = BufferEncoding.utf8;
    final Buffer expected = Buffer.fromList(
      [117, 116, 102, 45, 56, 32, 101, 110, 99, 111, 100, 105, 110, 103],
    );
    final Buffer buffer = Buffer.fromString(encoded, encoding);
    assert(listEquals(buffer.toList(), expected.toList()));
  });

  /// Slice
  test('slice', () {
    final Buffer buffer = Buffer.fromList([1, 2, 3, 4, 5, 6, 7, 8]);
    final Buffer sliced = buffer.slice(0, buffer.length ~/ 2);
    for (int i = 0; i < sliced.length; ++i) {
      assert(sliced[i] == buffer[i]);
    }
  });

  /// Copy
  test('copy', () {
    final Buffer buffer = Buffer.fromList([1, 2, 3, 4, 5, 6, 7, 8]);
    final Buffer cloned = Buffer(buffer.length);
    buffer.copy(cloned);
    assert(listEquals(buffer.toList(), cloned.toList()));
  });

  /// Strings
  const String stringValue = '4869204B617465';
  final Buffer stringBuffer = Buffer.fromList([72, 105, 32, 75, 97, 116, 101]);
  test('get string', () {
    final Buffer buffer = stringBuffer.slice();
    final String hex = buffer.getString(BufferEncoding.hex);
    assert(hex == stringValue);
  });
  test('set string', () {
    const int offset = 0;
    const int length = 2;
    final Buffer buffer = Buffer(stringBuffer.length);
    buffer.setString(stringValue, BufferEncoding.hex, offset, length);
    final Buffer testBuffer = Buffer(stringBuffer.length);
    stringBuffer.copy(testBuffer, 0, offset, length);
    assert(listEquals(buffer.toList(), testBuffer.toList()));
    buffer.setString(stringValue, BufferEncoding.hex, offset);
    assert(listEquals(buffer.toList(), stringBuffer.toList()));
  });

  /// Signed Ints
  const int intValueLE = 4091987;
  const int intValueBE = 5468222;
  final Buffer intBuffer = Buffer.fromList([83, 112, 62]);
  test('get int', () {
    assert(intValueLE == intBuffer.getInt(0, intBuffer.length));
    assert(intValueBE == intBuffer.getInt(0, intBuffer.length, Endian.big));
  });
  test('set int', () {
    final Buffer buffer = Buffer(intBuffer.length);
    buffer.setInt(intValueLE, 0, buffer.length);
    assert(listEquals(buffer.toList(), intBuffer.toList()));
    buffer.setInt(intValueBE, 0, buffer.length, Endian.big);
    assert(listEquals(buffer.toList(), intBuffer.toList()));
  });

  /// 8-bit Signed Ints
  const int int8Value = -1;
  final Buffer int8Buffer = Buffer.fromList([int8Value]); // [255]
  test('get 8-bit int', () {
    assert(int8Value == int8Buffer.getInt8(0));
  });
  test('set 8-bit int', () {
    final Buffer buffer = Buffer(int8Buffer.length);
    buffer.setInt8(int8Value, 0);
    assert(listEquals(buffer.toList(), int8Buffer.toList()));
  });

  /// 16-bit Signed Ints
  const int int16ValueLE = 4104;
  const int int16ValueBE = 2064;
  final Buffer int16Buffer = Buffer.fromList([8, 16]);
  test('get 16-bit int', () {
    assert(int16ValueLE == int16Buffer.getInt16(0));
    assert(int16ValueBE == int16Buffer.getInt16(0, Endian.big));
  });
  test('set 16-bit int', () {
    final Buffer buffer = Buffer(int16Buffer.length);
    buffer.setInt16(int16ValueLE, 0);
    assert(listEquals(buffer.toList(), int16Buffer.toList()));
    buffer.setInt16(int16ValueBE, 0, Endian.big);
    assert(listEquals(buffer.toList(), int16Buffer.toList()));
  });

  /// 32-bit Signed Ints
  const int int32ValueLE = 1075843080;
  const int int32ValueBE = 135274560;
  final Buffer int32Buffer = Buffer.fromList([8, 16, 32, 64]);
  test('get 32-bit int', () {
    assert(int32ValueLE == int32Buffer.getInt32(0));
    assert(int32ValueBE == int32Buffer.getInt32(0, Endian.big));
  });
  test('set 32-bit int', () {
    final Buffer buffer = Buffer(int32Buffer.length);
    buffer.setInt32(int32ValueLE, 0);
    assert(listEquals(buffer.toList(), int32Buffer.toList()));
    buffer.setInt32(int32ValueBE, 0, Endian.big);
    assert(listEquals(buffer.toList(), int32Buffer.toList()));
  });

  /// 64-bit Signed Ints
  const int int64ValueLE = 2310355955765743624;
  const int int64ValueBE = 580999813328801824;
  final Buffer int64Buffer = Buffer.fromList([8, 16, 32, 64, 128, 8, 16, 32]);
  test('get 64-bit int', () {
    assert(int64ValueLE == int64Buffer.getInt64(0));
    assert(int64ValueBE == int64Buffer.getInt64(0, Endian.big));
    /// [maxInt64]
    assert(maxInt64 == maxInt64Buffer.getInt64(0));
    assert(maxInt64 == maxInt64Buffer.getInt(0, maxInt64Buffer.length));
    /// [minInt64]
    assert(minInt64 == minInt64Buffer.getInt64(0));
    assert(minInt64 == minInt64Buffer.getInt(0, maxInt64Buffer.length));
  });
  test('set 64-bit int', () {
    final Buffer buffer = Buffer(int64Buffer.length);
    buffer.setInt64(int64ValueLE, 0);
    assert(listEquals(buffer.toList(), int64Buffer.toList()));
    buffer.setInt64(int64ValueBE, 0, Endian.big);
    assert(listEquals(buffer.toList(), int64Buffer.toList()));
    /// [maxInt64]
    buffer.setInt64(maxInt64, 0); 
    assert(listEquals(buffer.toList(), maxInt64Buffer.toList()));
    buffer.setInt(maxInt64, 0, minInt64Buffer.length);
    assert(listEquals(buffer.toList(), maxInt64Buffer.toList()));
    /// [minInt64]
    buffer.setInt64(minInt64, 0); 
    assert(listEquals(buffer.toList(), minInt64Buffer.toList()));
    buffer.setInt(minInt64, 0, minInt64Buffer.length);
    assert(listEquals(buffer.toList(), minInt64Buffer.toList()));
  });

  /// Unsigned Uints
  const int uintValueLE = 4950584;
  const int uintValueBE = 3705419;
  final Buffer uintBuffer = Buffer.fromList([56, 138, 75]);
  test('get uint', () {
    assert(uintValueLE == uintBuffer.getUint(0, uintBuffer.length));
    assert(uintValueBE == uintBuffer.getUint(0, uintBuffer.length, Endian.big));
  });
  test('set uint', () {
    final Buffer buffer = Buffer(uintBuffer.length);
    buffer.setUint(uintValueLE, 0, uintBuffer.length);
    assert(listEquals(buffer.toList(), uintBuffer.toList()));
    buffer.setUint(uintValueBE, 0, uintBuffer.length, Endian.big);
    assert(listEquals(buffer.toList(), uintBuffer.toList()));
  });

  /// 8-bit Uints
  const int uint8Value = 128;
  const int uint8MaxValue = 255;
  final Buffer uint8Buffer = Buffer.fromList([uint8Value]);
  test('get 8-bit uint', () {
    assertRange(uint8Value, max: uint8MaxValue);
    assert(uint8Value == uint8Buffer.getUint8(0));
  });
  test('set 8-bit uint', () {
    assertRange(uint8Value, max: uint8MaxValue);
    final Buffer buffer = Buffer(1);
    buffer.setUint8(uint8Value, 0);
    assert(listEquals(buffer.toList(), uint8Buffer.toList()));
  });

  /// 16-bit Uints
  const int uint16ValueLE = 27231;
  const int uint16ValueBE = 24426;
  final Buffer uint16Buffer = Buffer.fromList([95, 106]);
  test('get 16-bit uint', () {
    assertRange(uint16ValueLE, max: maxUint16);
    assert(uint16ValueLE == uint16Buffer.getUint16(0));
    assertRange(uint16ValueBE, max: maxUint16);
    assert(uint16ValueBE == uint16Buffer.getUint16(0, Endian.big));
  });
  test('set 16-bit uint', () {
    final Buffer buffer = Buffer(uint16Buffer.length);
    buffer.setInt16(uint16ValueLE, 0);
    assert(listEquals(buffer.toList(), uint16Buffer.toList()));
    buffer.setInt16(uint16ValueBE, 0, Endian.big);
    assert(listEquals(buffer.toList(), uint16Buffer.toList()));
  });

  /// 32-bit Uints
  const int uint32ValueLE = 135282712;
  const int uint32ValueBE = 406851592;
  final Buffer uint32Buffer = Buffer.fromList([24, 64, 16, 8]);
  test('get 32-bit uint', () {
    assert(uint32ValueLE == uint32Buffer.getUint32(0));
    assert(uint32ValueBE == uint32Buffer.getUint32(0, Endian.big));
  });
  test('set 32-bit uint', () {
    final Buffer buffer = Buffer(uint32Buffer.length);
    buffer.setUint32(uint32ValueLE, 0);
    assert(listEquals(buffer.toList(), uint32Buffer.toList()));
    buffer.setUint32(uint32ValueBE, 0, Endian.big);
    assert(listEquals(buffer.toList(), uint32Buffer.toList()));
  });

  /// 64-bit Uints
  final BigInt uint64ValueLE = BigInt.from(6797927951541548548);
  final BigInt uint64ValueBE = BigInt.from(303524000726210398);
  final Buffer uint64Buffer = Buffer.fromList([4, 54, 85, 120, 116, 23, 87, 94]);
  test('get 64-bit uint', () {
    assert(uint64ValueLE == uint64Buffer.getUint64(0));
    assert(uint64ValueBE == uint64Buffer.getUint64(0, Endian.big));
  });
  test('set 64-bit uint', () {
    final Buffer buffer = Buffer(uint64Buffer.length);
    buffer.setUint64(uint64ValueLE, 0);
    assert(listEquals(buffer.toList(), uint64Buffer.toList()));
    buffer.setUint64(uint64ValueBE, 0, Endian.big);
    assert(listEquals(buffer.toList(), uint64Buffer.toList()));
  });

  /// 64-bit Uints (Max Values)
  test('get max 64-bit uint', () {
    assert(maxUInt64 == maxUInt64Buffer.getUint64(0));
  });
  test('set max 64-bit uint', () {
    final Buffer buffer = Buffer(maxUInt64Buffer.length);
    buffer.setUint64(maxUInt64, 0);
    assert(listEquals(buffer.toList(), maxUInt64Buffer.toList()));
  });

  /// 32-bit Float
  const double float32ValueLE = 2.1426990032196045;
  const double float32ValueBE = -8.36147406512941e+35;
  final Buffer float32Buffer = Buffer.fromList([251, 33, 9, 64]);
  test('get 32-bit float', () {
    assert(float32ValueLE == float32Buffer.getFloat32(0));
    assert(float32ValueBE == float32Buffer.getFloat32(0, Endian.big));
  });
  test('set 32-bit float', () {
    final Buffer buffer = Buffer(float32Buffer.length);
    buffer.setFloat32(float32ValueLE, 0);
    assert(listEquals(buffer.toList(), float32Buffer.toList()));
    buffer.setFloat32(float32ValueBE, 0, Endian.big);
    assert(listEquals(buffer.toList(), float32Buffer.toList()));
  });

  /// 64-bit Float
  const double float64ValueLE = 3.14159265359;
  const double float64ValueBE = -2.965482352282314e+203;
  final Buffer float64Buffer = Buffer.fromList([234, 46, 68, 84, 251, 33, 9, 64]);
  test('get 64-bit float', () {
    assert(float64ValueLE == float64Buffer.getFloat64(0));
    assert(float64ValueBE == float64Buffer.getFloat64(0, Endian.big));
  });
  test('set 64-bit float', () {
    final Buffer buffer = Buffer(float64Buffer.length);
    buffer.setFloat64(float64ValueLE, 0);
    assert(listEquals(buffer.toList(), float64Buffer.toList()));
    buffer.setFloat64(float64ValueBE, 0, Endian.big);
    assert(listEquals(buffer.toList(), float64Buffer.toList()));
  });
}