/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:convert' show base64, utf8;
import 'dart:math' show min, max;
import 'dart:typed_data';
import 'package:solana_web3/extensions/big_int.dart';
import 'package:solana_web3/utils/convert.dart' as convert;
import 'package:solana_web3/utils/library.dart' show require;


/// Buffer Encoding
/// ------------------------------------------------------------------------------------------------

enum BufferEncoding {
  
  base58,
  base64,
  hex,
  utf8,
  ;

  /// Returns the enum variant where [BufferEncoding.name] is equal to [name].
  /// 
  /// Returns [BufferEncoding.utf8] if [name] does not match an existing variant.
  /// 
  /// ```
  /// BufferEncoding.fromName('base58');
  /// ```
  factory BufferEncoding.fromName(final String? name) {
    return values.firstWhere(
      (final BufferEncoding item) => item.name == name, 
      orElse: () => BufferEncoding.utf8,
    );
  }
}


/// Buffer
/// ------------------------------------------------------------------------------------------------

class Buffer extends Iterable<int> {

  /// Creates a fixed [length] list of `8-bit` unsigned integers. 
  /// 
  /// Each item in the list is `zero` initialised.
  Buffer(final int length)
    : _data = Uint8List(length);

  /// The buffer's underlying data structure.
  final Uint8List _data;

  /// The bit length of a single item.
  static const int _bits = 8;

  /// The bit mask of a single item.
  static const int _mask = 0xFF;

  /// Returns the byte at [index].
  int operator [](final int index) => _data[index];

  /// Sets the byte [value] at [index].
  void operator []=(final int index, final int value) => _data[index] = value;

  /// Creates a [Buffer] from a list of [bytes].
  factory Buffer.fromList(final Iterable<int> bytes) {
    return Buffer(bytes.length).._data.setAll(0, bytes);
  }

  /// Creates a [Buffer] from an [encoded] string.
  /// 
  /// ```
  /// const String hexString = '00FF';
  /// final Buffer buffer = Buffer.fromString(hexString, BufferEncoding.hex);
  /// print(buffer); // [0, 255]
  /// ```
  factory Buffer.fromString(
    final String encoded, [ 
    final BufferEncoding encoding = BufferEncoding.utf8, 
  ]) {
    return Buffer.fromList(_decode(encoded, encoding));
  }

  /// The number of items in the buffer.
  @override
  int get length => _data.length;

  /// Returns a new [Iterator] to walk through the items in the buffer.
  @override
  Iterator<int> get iterator => _data.iterator;

  /// Returns an [Iterable] to walk through the items in reverse order.
  Iterable<int> get reversed => _data.reversed;

  /// Creates a [Uint8List] view over the buffer.
  /// 
  /// Changes made to the returned view will reflect in the buffer.
  Uint8List asUint8List() => _data;

  /// Creates a [ByteData] view over a region of the buffer. 
  /// 
  /// The view starts at the zero indexed [offset] and contains [length] items. If [length] is 
  /// omitted, the range extends to the end of the buffer.
  /// 
  /// Changes made to the returned view will reflect in the buffer.
  /// 
  /// The range must satisy the relations `0` ≤ `offset` ≤ `offset+length` ≤ `this.length`.
  ByteData asByteData([final int offset = 0, final int? length]) { 
    return _data.buffer.asByteData(offset, length);
  }

  /// Creates a new [Buffer] from a region of `this` buffer.
  /// 
  /// Items are copied from the range `[offset : offset+length]`. If [length] is omitted, the range 
  /// extends to the end of the buffer.
  /// 
  /// The range must satisy the relations `0` ≤ `offset` ≤ `offset+length` ≤ `this.length`.
  /// 
  /// ```
  /// final Buffer buffer = Buffer.fromList([1, 2, 3, 4, 5, 6, 7, 8]);
  /// final Buffer newBuffer = buffer.slice(4);
  /// print(buffer);    // [1, 2, 3, 4, 5, 6, 7, 8]
  /// print(newBuffer); // [5, 6, 7, 8]
  /// ```
  Buffer slice([final int offset = 0, final int? length]) {
    final int? end = length != null ? offset + length : null;
    return Buffer.fromList(_data.sublist(offset, end));
  }

  /// Copies items from `this` buffer to the destination ([dst]) buffer.
  /// 
  /// Items are copied to [dst] starting at position [dstOffset]. 
  /// 
  /// Items are copied from the range `[offset : offset+length]`. If [length] is omitted, the range 
  /// extends to the end of `this` or `[dst]` (whichever has the minimum length).
  /// 
  /// The range must satisy the relations `0` ≤ `offset` ≤ `offset+length` ≤ `this.length`.
  /// 
  /// ```
  /// final Buffer src = Buffer.fromList([1, 2, 3, 4, 5, 6, 7, 8]);
  /// final Buffer dst = Buffer(4);
  /// src.copy(dst, 0, 2);
  /// print(src); // [1, 2, 3, 4, 5, 6, 7, 8]
  /// print(dst); // [3, 4, 5, 6]
  /// ```
  void copy(
    final Buffer dst, [
    final int dstOffset = 0, 
    final int offset = 0, 
    final int? length,
  ]) {
    final int rngLength = length ?? min(dst.length - dstOffset, this.length - offset);
    final Iterable<int> src = _data.getRange(offset, offset + rngLength);
    dst._data.setRange(dstOffset, dstOffset + rngLength, src);
  }

  /// Reads a region of the buffer.
  /// 
  /// Items are read from the range `[offset : offset+length]`. If [length] is omitted, the range 
  /// extends to the end of the buffer.
  /// 
  /// The range must satisy the relations `0` ≤ `offset` ≤ `offset+length` ≤ `this.length`.
  /// 
  /// ```
  /// final Buffer buffer = Buffer.fromList([1, 2, 3, 4, 5, 6, 7, 8]);
  /// print(buffer.getRange());     // [1, 2, 3, 4, 5, 6, 7, 8]
  /// print(buffer.getRange(2));    // [3, 4, 5, 6, 7, 8]
  /// print(buffer.getRange(2, 4)); // [3, 4, 5, 6]
  /// ```
  Iterable<int> getRange([final int offset = 0, final int? length]) {
    final int rngLength = length ?? this.length - offset;
    return _data.getRange(offset, rngLength);
  }

  /// Writes a `byte array` to a region of the buffer starting at [offset].
  /// 
  /// If [offset] + [bytes.length] exceeds [length], the range extends to the end of the buffer.
  /// 
  /// The offset must satisy the relations `0` ≤ `offset` ≤ `this.length`.
  /// ```
  /// final Buffer buf = Buffer.fromList([0, 0, 0, 0, 0, 0, 0, 0]);
  /// print(buf); // [0, 0, 0, 0, 0, 0, 0, 0]
  /// 
  /// buf.setAll(2, [1, 2, 3, 4]);
  /// print(buf); // [0, 0, 1, 2, 3, 4, 0, 0]
  /// 
  /// buf.setAll(6, [5, 6, 7, 8]);
  /// print(buf); // [0, 0, 1, 2, 3, 4, 5, 6]
  /// ```
  void setAll(
    final int offset, 
    final Iterable<int> bytes,
  ) {
    _data.setAll(offset, bytes);
  }

  /// Reads a region of the buffer as an `encoded string`.
  /// 
  /// Items are read from the range `[offset : offset+length]`. If [length] is omitted, the range 
  /// extends to the end of the buffer.
  /// 
  /// The range must satisy the relations `0` ≤ `offset` ≤ `offset+length` ≤ `this.length`.
  /// 
  /// ```
  /// final Buffer buffer = Buffer.fromList([72, 105, 32, 75, 97, 116, 101]);
  /// final String hex = buffer.getString(BufferEncoding.hex);
  /// print(hex); // '4869204B617465'
  /// ```
  String getString(final BufferEncoding encoding, [final int offset = 0, final int? length]) {
    final Iterable<int> bytes = getRange(offset, length);
    return _encode(Uint8List.fromList(bytes.toList(growable: false)), encoding);
  }

  /// Writes an `[encoded] string` to a region of the buffer.
  /// 
  /// The [encoded] string is written to the range `[offset : offset+length]`. If [length] is 
  /// omitted, the range extends to the end of the buffer.
  /// 
  /// The range must satisy the relations `0` ≤ `offset` ≤ `offset+length` ≤ `this.length`.
  /// 
  /// ```
  /// final Buffer buffer = Buffer(7);
  /// const String value = '4869204B617465';
  /// buffer.setString(value, BufferEncoding.hex, 0, 2);
  /// print(buffer); // [72, 105, 0, 0, 0, 0, 0]
  /// buffer.setString(value, BufferEncoding.hex, 0);
  /// print(buffer); // [72, 105, 32, 75, 97, 116, 101]
  /// ```
  void setString(
    final String encoded, 
    final BufferEncoding encoding, [
    final int offset = 0, 
    final int? length,
  ]) {
    final Iterable<int> bytes = _decode(encoded, encoding);
    final int rngLength = length ?? min(this.length - offset, bytes.length);
    _data.setRange(offset, offset + rngLength, bytes);
  }

  /// Reads a region of the buffer as a `signed integer`.
  /// 
  /// Items are read from the range `[offset : offset+length]`.
  /// 
  /// The range must satisy the relations `0` ≤ `offset` ≤ `offset+length` ≤ `this.length`.
  /// 
  /// ```
  /// final Buffer buffer = Buffer.fromList([83, 112, 62]);
  /// final int value = buffer.getInt(0, 3);
  /// print(value); // 4091987
  /// ```
  int getInt(final int offset, final int length, [final Endian endian = Endian.little]) {
    return getUint(offset, length, endian).toSigned(length * _bits);
  }

  /// Writes a `signed integer` to a region of the buffer.
  /// 
  /// Returns the position of the last element written to the buffer (`[offset]+[length]`).
  /// 
  /// The [value] is written to the range `[offset : offset+length]`.
  /// 
  /// The range must satisy the relations `0` ≤ `offset` ≤ `offset+length` ≤ `this.length`.
  /// 
  /// ```
  /// final Buffer buffer = Buffer(3);
  /// buffer.setInt(4091987, 0, 3);
  /// print(buffer); // [83, 112, 62]
  /// ```
  int setInt(
    final int value, 
    final int offset, 
    final int length, [
    final Endian endian = Endian.little,
  ]) {
    return _setBytes(_toBytes(value, length), offset, endian);
  }
  
  /// Reads a region of the buffer as an `unsigned big integer`.
  /// 
  /// Items are read from the range `[offset : offset+length]`.
  /// 
  /// The range must satisy the relations `0` ≤ `offset` ≤ `offset+length` ≤ `this.length`.
  /// 
  /// ```
  /// final Buffer buffer = Buffer.fromList([255, 255, 31, 236, 95, 13, 82, 66, 20, 2]);
  /// final BigInt value = buffer.getBigInt(0, buffer.length);
  /// print(value); // 9818446744073709551615
  /// ```
  BigInt getBigInt(final int offset, final int length, [final Endian endian = Endian.little]) {
    return getBigUint(offset, length, endian).toSigned(length * _bits);
  }

  /// Writes a `big unsigned integer` to a region of the buffer.
  /// 
  /// Returns the position of the last element written to the buffer (`[offset]+[length]`).
  /// 
  /// The [value] is written to the range `[offset : offset+length]`. If [length] is omitted, the 
  /// minimum number of bytes required to store this big integer value is used.
  /// 
  /// The range must satisy the relations `0` ≤ `offset` ≤ `offset+length` ≤ `this.length`.
  /// 
  /// ```
  /// final Buffer buffer = Buffer(10);
  /// buffer.setBigInt(BigInt.parse('9818446744073709551615'), 0);
  /// print(buffer); // [255, 255, 31, 236, 95, 13, 82, 66, 20, 2]
  /// ```
  int setBigInt(
    final BigInt value, 
    final int offset, [
    final int? length,
    final Endian endian = Endian.little,
  ]) {
    return _setBytes(_toBytesBigInt(value), offset, endian);
  }

  /// Reads `1-byte` as a `signed integer`.
  /// 
  /// The [offset] must satisy the relations `0` ≤ `offset` ≤ `offset+1` ≤ `this.length`.
  /// 
  /// ```
  /// final Buffer buffer = Buffer.fromList([-1]);
  /// final int value = buffer.getInt8(0);
  /// print(value); // -1
  /// ```
  int getInt8(final int offset) {
    return asByteData().getInt8(offset);
  }
  
  /// Writes a `signed integer` to `1-byte`. 
  /// 
  /// If [value] falls outside the range `0 : 255` (inclusive), the integer is overflow (e.g. 
  /// `-2 -> [254]`, `-1 -> [255]`, ..., `256 -> [0]` and `257 -> [1]`).
  /// 
  /// The [offset] must satisy the relations `0` ≤ `offset` ≤ `offset+1` ≤ `this.length`.
  /// 
  /// ```
  /// final Buffer buffer = Buffer(1);
  /// buffer.setInt8(-1, 0);
  /// print(buffer); // [255]
  /// ```
  void setInt8(final int value, final int offset) {
    return asByteData().setInt8(offset, value);
  }

  /// Reads `2-bytes` as a `signed integer`.
  /// 
  /// The [offset] must satisy the relations `0` ≤ `offset` ≤ `offset+2` ≤ `this.length`.
  /// 
  /// ```
  /// final Buffer buffer = Buffer.fromList([8, 16]);
  /// final int value = buffer.getInt16(0);
  /// print(value); // 4104
  /// ```
  int getInt16(final int offset, [final Endian endian = Endian.little]) {
    return asByteData().getInt16(offset, endian);
  }

  /// Writes a `signed integer` to `2-bytes`. 
  /// 
  /// The [offset] must satisy the relations `0` ≤ `offset` ≤ `offset+2` ≤ `this.length`.
  /// 
  /// ```
  /// final Buffer buffer = Buffer(2);
  /// buffer.setInt16(4104, 0);
  /// print(buffer); // [8, 16]
  /// ```
  void setInt16(final int value, final int offset, [final Endian endian = Endian.little]) {
    return asByteData().setInt16(offset, value, endian);
  }

  /// Reads `4-bytes` as a `signed integer`.
  /// 
  /// The [offset] must satisy the relations `0` ≤ `offset` ≤ `offset+4` ≤ `this.length`.
  /// 
  /// ```
  /// final Buffer buffer = Buffer.fromList([8, 16, 32, 64]);
  /// final int value = buffer.getInt32(0);
  /// print(value); // 1075843080
  /// ```
  int getInt32(final int offset, [final Endian endian = Endian.little]) {
    return asByteData().getInt32(offset, endian);
  }

  /// Writes a `signed integer` to `4-bytes`. 
  /// 
  /// The [offset] must satisy the relations `0` ≤ `offset` ≤ `offset+4` ≤ `this.length`.
  /// 
  /// ```
  /// final Buffer buffer = Buffer(4);
  /// buffer.setInt32(1075843080, 0);
  /// print(buffer); // [8, 16, 32, 64]
  /// ```
  void setInt32(final int value, final int offset, [final Endian endian = Endian.little]) {
    return asByteData().setInt32(offset, value, endian);
  }
  
  /// Reads `8-bytes` as a `signed integer`.
  /// 
  /// The [offset] must satisy the relations `0` ≤ `offset` ≤ `offset+8` ≤ `this.length`.
  /// 
  /// ```
  /// final Buffer buffer = Buffer.fromList([8, 16, 32, 64, 128, 8, 16, 32]);
  /// final int value = buffer.getInt64(0);
  /// print(value); // 2310355955765743624
  /// ```
  int getInt64(final int offset, [final Endian endian = Endian.little]) {
    return asByteData().getInt64(offset, endian);
  }

  /// Writes a `signed integer` to `8-bytes`. 
  /// 
  /// The [offset] must satisy the relations `0` ≤ `offset` ≤ `offset+8` ≤ `this.length`.
  /// 
  /// ```
  /// final Buffer buffer = Buffer(8);
  /// buffer.setInt64(2310355955765743624, 0);
  /// print(buffer); // [8, 16, 32, 64, 128, 8, 16, 32] 
  /// ```
  void setInt64(final int value, final int offset, [final Endian endian = Endian.little]) {
    return asByteData().setInt64(offset, value, endian);
  }

  /// Reads a region of the buffer as a `big endian unsigned integer`.
  int _getUintBE(Iterable<int> bytes) {
    return bytes.fold(0, (final int value, final int byte) => value << _bits | byte);
  }

  /// Reads a region of the buffer as a `little endian unsigned integer`.
  int _getUintLE(Iterable<int> bytes) {
    int i = 0;
    return bytes.fold(0, (final int value, final int byte) => byte << (i++ * _bits) | value);
  }

  /// Reads a region of the buffer as an `unsigned integer`.
  /// 
  /// Items are read from the range `[offset : offset+length]`.
  /// 
  /// The range must satisy the relations `0` ≤ `offset` ≤ `offset+length` ≤ `this.length`.
  /// 
  /// ```
  /// final Buffer buffer = Buffer.fromList([56, 138, 75]);
  /// final int value = buffer.getUint(0, 3);
  /// print(value); // 4950584
  /// ```
  int getUint(final int offset, final int length, [final Endian endian = Endian.little]) {
    final Iterable<int> values = _data.getRange(offset, offset + length);
    return endian == Endian.big ? _getUintBE(values) : _getUintLE(values);
  }

  /// Writes an `unsigned integer` to a region of the buffer.
  /// 
  /// Returns the position of the last element written to the buffer (`[offset]+[length]`).
  /// 
  /// The [value] is written to the range `[offset : offset+length]`.
  /// 
  /// The range must satisy the relations `0` ≤ `offset` ≤ `offset+length` ≤ `this.length`.
  /// 
  /// ```
  /// final Buffer buffer = Buffer(3);
  /// buffer.setUint(4950584, 0, 3);
  /// print(buffer); // [56, 138, 75]
  /// ```
  int setUint(
    final int value, 
    final int offset, 
    final int length, [
    final Endian endian = Endian.little,
  ]) {
    require(value >= 0, 'The [int] value $value must be a positive integer.');
    return setInt(value, offset, length, endian);
  }

  /// Reads a region of the buffer as a `big unsigned integer` in `big endian`.
  BigInt _getBigUintBE(Iterable<int> bytes) {
    return bytes.fold(
      BigInt.zero, 
      (final BigInt value, final int byte) => value << _bits | BigInt.from(byte),
    );
  }

  /// Reads a region of the buffer as a `big unsigned integer` in `little endian`.
  BigInt _getBigUintLE(Iterable<int> bytes) {
    int i = 0;
    return bytes.fold(
      BigInt.zero, 
      (final BigInt value, final int byte) => BigInt.from(byte) << (i++ * _bits) | value,
    );
  }
  
  /// Reads a region of the buffer as an `big unsigned integer`.
  /// 
  /// Items are read from the range `[offset : offset+length]`.
  /// 
  /// The range must satisy the relations `0` ≤ `offset` ≤ `offset+length` ≤ `this.length`.
  /// 
  /// ```
  /// final Buffer buffer = Buffer.fromList([255, 255, 255, 255, 255, 255, 255, 255]);
  /// final BigInt value = buffer.getBigUint(0, buffer.length);
  /// print(value); // 18446744073709551615
  /// ```
  BigInt getBigUint(final int offset, final int length, [final Endian endian = Endian.little]) {
    final Iterable<int> bytes = _data.getRange(offset, offset + length);
    return endian == Endian.big ? _getBigUintBE(bytes) : _getBigUintLE(bytes);
  }

  /// Writes a `big unsigned integer` to a region of the buffer.
  /// 
  /// Returns the position of the last element written to the buffer (`[offset]+[length]`).
  /// 
  /// The [value] is written to the range `[offset : offset+length]`. If [length] is omitted, it 
  /// defaults to the [value]'s byte length.
  /// 
  /// The range must satisy the relations `0` ≤ `offset` ≤ `offset+length` ≤ `this.length`.
  /// 
  /// ```
  /// final Buffer buffer = Buffer(8);
  /// buffer.setBigUint(BigInt.parse('18446744073709551615'), 0);
  /// print(buffer); // [255, 255, 255, 255, 255, 255, 255, 255]
  /// ```
  int setBigUint(
    final BigInt value, 
    final int offset, [
    final int? length,
    final Endian endian = Endian.little,
  ]) {
    require(value >= BigInt.zero, 'The [BigInt] value $value must be a positive integer.');
    return setBigInt(value, offset, length, endian);
  }

  /// Reads `1-byte` as an `unsigned integer`.
  /// 
  /// The [offset] must satisy the relations `0` ≤ `offset` ≤ `offset+1` ≤ `this.length`.
  /// 
  /// ```
  /// final Buffer buffer = Buffer.fromList([128]);
  /// final int value = buffer.getUint8(0);
  /// print(value); // 128
  /// ```
  int getUint8(final int offset) {
    return asByteData().getUint8(offset);
  }

  /// Writes an `unsigned integer` to `1-byte`. 
  /// 
  /// If [value] falls outside the range `0 : 255` (inclusive), the integer is overflow (e.g. 
  /// `-2 -> [254]`, `-1 -> [255]`, ..., `256 -> [0]` and `257 -> [1]`).
  /// 
  /// The [offset] must satisy the relations `0` ≤ `offset` ≤ `offset+1` ≤ `this.length`.
  /// 
  /// ```
  /// final Buffer buffer = Buffer(1);
  /// buffer.setUint8(128, 0);
  /// print(buffer); // [128]
  /// ```
  void setUint8(final int value, final int offset) {
    return asByteData().setUint8(offset, value);
  }

  /// Reads `2-bytes` as an `unsigned integer`.
  /// 
  /// The [offset] must satisy the relations `0` ≤ `offset` ≤ `offset+2` ≤ `this.length`.
  /// 
  /// ```
  /// final Buffer buffer = Buffer.fromList([95, 106]);
  /// final int value = buffer.getUint16(0);
  /// print(value); // 27231
  /// ```
  int getUint16(final int offset, [final Endian endian = Endian.little]) {
    return asByteData().getUint16(offset, endian);
  }

  /// Writes an `unsigned integer` to `2-bytes`. 
  /// 
  /// The [offset] must satisy the relations `0` ≤ `offset` ≤ `offset+2` ≤ `this.length`.
  /// 
  /// ```
  /// final Buffer buffer = Buffer(2);
  /// buffer.setUint16(27231, 0);
  /// print(buffer); // [95, 106]
  /// ```
  void setUint16(final int value, final int offset, [final Endian endian = Endian.little]) {
    return asByteData().setUint16(offset, value, endian);
  }

  /// Reads `4-bytes` as an `unsigned integer`.
  /// 
  /// The [offset] must satisy the relations `0` ≤ `offset` ≤ `offset+4` ≤ `this.length`.
  /// 
  /// ```
  /// final Buffer buffer = Buffer.fromList([24, 64, 16, 8]);
  /// final int value = buffer.getUint32(0);
  /// print(value); // 135282712
  /// ```
  int getUint32(final int offset, [final Endian endian = Endian.little]) {
    return asByteData().getUint32(offset, endian);
  }

  /// Writes an `unsigned integer` to `4-bytes`. 
  /// 
  /// The [offset] must satisy the relations `0` ≤ `offset` ≤ `offset+4` ≤ `this.length`.
  /// 
  /// ```
  /// final Buffer buffer = Buffer(4);
  /// buffer.setUint32(135282712, 0);
  /// print(buffer); // [24, 64, 16, 8]
  /// ```
  void setUint32(final int value, final int offset, [final Endian endian = Endian.little]) {
    return asByteData().setUint32(offset, value, endian);
  }

  /// Reads `8-bytes` as an `unsigned integer`.
  /// 
  /// The [offset] must satisy the relations `0` ≤ `offset` ≤ `offset+8` ≤ `this.length`.
  /// 
  /// ```
  /// final Buffer buffer = Buffer.fromList([4, 54, 85, 120, 116, 23, 87, 94]);
  /// final int value = buffer.getUint64(0);
  /// print(value); // 6797927951541548548
  /// ```
  BigInt getUint64(final int offset, [final Endian endian = Endian.little]) {
    return getBigUint(offset, 8, endian);
  }
  
  /// Writes an `unsigned integer` to `8-bytes`. 
  /// 
  /// The [offset] must satisy the relations `0` ≤ `offset` ≤ `offset+8` ≤ `this.length`.
  /// 
  /// ```
  /// final Buffer buffer = Buffer(8);
  /// buffer.setInt64(6797927951541548548, 0);
  /// print(buffer); // [4, 54, 85, 120, 116, 23, 87, 94]
  /// ```
  void setUint64(final BigInt value, final int offset, [final Endian endian = Endian.little]) {
    setBigUint(value, offset, 8, endian);
  }
  
  /// Reads `4-bytes` as a `floating point` value.
  /// 
  /// The [offset] must satisy the relations `0` ≤ `offset` ≤ `offset+2` ≤ `this.length`.
  /// 
  /// ```
  /// final Buffer buffer = Buffer.fromList([251, 33, 9, 64]);
  /// final double value = buffer.getFloat32(0);
  /// print(value); // 2.1426990032196045
  /// ```
  double getFloat32(final int offset, [final Endian endian = Endian.little]) {
    return asByteData().getFloat32(offset, endian);
  }
  
  /// Writes a `floating point` [value] to `4-bytes`. 
  /// 
  /// The [offset] must satisy the relations `0` ≤ `offset` ≤ `offset+length` ≤ `this.length`.
  /// 
  /// ```
  /// final Buffer buffer = Buffer(4);
  /// buffer.setFloat32(2.1426990032196045, 0);
  /// print(buffer); // [251, 33, 9, 64]
  /// ```
  void setFloat32(final double value, final int offset, [final Endian endian = Endian.little]) {
    return asByteData().setFloat32(offset, value, endian);
  }

  /// Reads `8-bytes` as a `double precision floating point` value.
  /// 
  /// The [offset] must satisy the relations `0` ≤ `offset` ≤ `offset+2` ≤ `this.length`.
  /// 
  /// ```
  /// final Buffer buffer = Buffer.fromList([234, 46, 68, 84, 251, 33, 9, 64]);
  /// final double value = buffer.getFloat64(0);
  /// print(value); // 3.14159265359
  /// ```
  double getFloat64(final int offset, [final Endian endian = Endian.little]) {
    return asByteData().getFloat64(offset, endian);
  }

  /// Writes a `double precision floating point` [value] to `8-bytes`. 
  /// 
  /// The [offset] must satisy the relations `0` ≤ `offset` ≤ `offset+length` ≤ `this.length`.
  /// 
  /// ```
  /// final Buffer buffer = Buffer(8);
  /// buffer.setFloat64(3.14159265359, 0);
  /// print(buffer); // [234, 46, 68, 84, 251, 33, 9, 64]
  /// ```
  void setFloat64(final double value, final int offset, [final Endian endian = Endian.little]) {
    return asByteData().setFloat64(offset, value, endian);
  }

  /// Writes a `byte array` to the buffer.
  /// 
  /// Returns the position of the last element written to the buffer (`[offset]+[bytes.length]`).
  /// 
  /// The [bytes] array is written to the range `[offset : offset+bytes.length]`.
  /// 
  /// The range must satisy the relations `0` ≤ `offset` ≤ `offset+bytes.length` ≤ `this.length`.
  int _setBytes(
    final Uint8List bytes, 
    final int offset, [
    final Endian endian = Endian.little,
  ]) {
    _data.setAll(offset, endian == Endian.big ? bytes.reversed : bytes);
    return offset + bytes.length;
  }

  /// Converts an integer [value] to a byte array of size [length].
  /// 
  /// ```
  /// _toBytes(256, 4);       // [0, 1, 0, 0]
  /// _toBytes(-1, 4);        // [255, 255, 255, 255]
  /// ```
  Uint8List _toBytes(int value, final int length) {
    final Uint8List bytes = Uint8List(length);
    for (int i = 0; i < bytes.length && value != 0; ++i) {
      bytes[i] = value & _mask;
      value >>= _bits;
    }
    require(value <= 0, 'The [int] value $value overflows ${bytes.length} byte(s).');
    return bytes;
  }

  /// Converts a big integer [value] to a byte array of size [length].
  /// 
  /// ```
  /// final BigInt input = BigInt.parse('-9818446744073709551615');
  /// final Uint8List bytes = _toBytesBigInt(input);
  /// print(bytes); // [1, 0, 224, 19, 160, 242, 173, 189, 235, 253]
  /// 
  /// final BigInt output = BigIntExtension.fromUint8List(bytes);
  /// print(output.asSigned()); // '-9818446744073709551615'
  /// ```
  Uint8List _toBytesBigInt(BigInt value, [final int? length]) {
    final BigInt mask = BigInt.from(Buffer._mask);
    final Uint8List bytes = Uint8List(length ?? value.byteLength);
    for (int i = 0; i < bytes.length && value != BigInt.zero; ++i) {
      bytes[i] = (value & mask).toInt();
      value >>= _bits;
    }
    require(value <= BigInt.zero, 'The [BigInt] value $value overflows ${bytes.length} byte(s).');
    return bytes;
  }

  /// Converts an array of [bytes] to an encoded string.
  static String _encode(final Uint8List bytes, final BufferEncoding encoding) {
    switch(encoding) {
      case BufferEncoding.base58:
        return convert.base58.encode(bytes);
      case BufferEncoding.base64:
        return base64.encode(bytes);
      case BufferEncoding.hex:
        return convert.hex.encode(bytes);
      case BufferEncoding.utf8:
        return utf8.decode(bytes);
    }
  }

  /// Converts an [encoded] string to an array of bytes.
  static Iterable<int> _decode(final String encoded, BufferEncoding encoding) {
    switch(encoding) {
      case BufferEncoding.base58:
        return convert.base58.decode(encoded);
      case BufferEncoding.base64:
        return base64.decode(encoded);
      case BufferEncoding.hex:
        return convert.hex.decode(encoded);
      case BufferEncoding.utf8:
        return utf8.encode(encoded);
    }
  }
}