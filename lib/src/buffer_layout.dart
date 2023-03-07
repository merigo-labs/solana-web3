/// A dart implementation of the @solana/buffer-layout library.
/// Source code: https://github.com/pabigot/buffer-layout/blob/main/lib/Layout.js

/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:typed_data';
import 'package:solana_common/utils/buffer.dart';
import 'package:solana_common/utils/utils.dart' as utils show check;


/// Layout Mixin
/// ------------------------------------------------------------------------------------------------

mixin LayoutMixin {

  /// Asserts that [condition] is `true`.
  /// 
  /// Throws an [AssertionError] with the provided [message] if [condition] is `false`.
  void check(final bool condition, final String message) {
    return utils.check(condition, '[$runtimeType] $message');
  }

  /// Formats the [property] text to be used as the prefix of an error message.
  String debugProperty(final String? property) {
    return property != null ? 'property = "$property"' : '';
  }
}


/// Layout Properties
/// ------------------------------------------------------------------------------------------------

abstract class LayoutProperties {

  /// Base class for layout objects.
  ///
  /// @param {Number} span - Initialiser for {@link Layout#span|span}.  The
  /// parameter must be an integer; a negative value signifies that the
  /// span is {@link Layout#getSpan|value-specific}.
  ///
  /// @param {string} [property] - Initialiser for {@link
  /// Layout#property|property}.
  const LayoutProperties(this.span, this.property);
  
  /// The span of the layout in bytes.
  /// 
  /// Positive values are generally expected.
  /// 
  /// Zero will only appear in {@link Constant}s and in {@link
  /// Sequence}s where the {@link Sequence#count|count} is zero.
  /// 
  /// A negative value indicates that the span is value-specific, and
  /// must be obtained using {@link Layout#getSpan|getSpan}.
  final int span;

  /// The property name used when this layout is represented in an
  /// Object.
  ///
  /// Used only for layouts that {@link Layout#decode|decode} to Object
  /// instances.  If left undefined the span of the unnamed layout will
  /// be treated as padding: it will not be mutated by {@link
  /// Layout#encode|encode} nor represented as a property in the
  /// decoded Object.
  final String? property;
}


/// Layout
/// ------------------------------------------------------------------------------------------------

abstract class Layout<T> extends LayoutProperties with LayoutMixin {

  /// Base class for layout objects.
  ///
  /// **NOTE** This is an abstract base class; you can create instances
  /// if it amuses you, but they won't support the {@link
  /// Layout#encode|encode} or {@link Layout#decode|decode} functions.
  ///
  /// @param {Number} span - Initialiser for {@link Layout#span|span}.  The
  /// parameter must be an integer; a negative value signifies that the
  /// span is {@link Layout#getSpan|value-specific}.
  ///
  /// @param {string} [property] - Initialiser for {@link
  /// Layout#property|property}.
  ///
  /// @abstract
  const Layout(super.span, super.property);

  /// Function to create an Object into which decoded properties will
  /// be written.
  ///
  /// Used only for layouts that {@link Layout#decode|decode} to Object
  /// instances, which means:
  /// * {@link Structure}
  /// * {@link Union}
  /// * {@link VariantLayout}
  /// * {@link BitStructure}
  ///
  /// If left undefined the JavaScript representation of these layouts
  /// will be Object instances.
  ///
  /// See {@link bindConstructorLayout}.
  Map<String, dynamic> makeDestinationObject() => {};

  /// Decode from a Buffer into an JavaScript value.
  ///
  /// @param {Buffer} b - the buffer from which encoded data is read.
  ///
  /// @param {Number} [offset] - the offset at which the encoded data
  /// starts.  If absent a zero offset is inferred.
  ///
  /// @returns {(Number|Array|Object)} - the value of the decoded data.
  ///
  /// @abstract
  T decode(final Buffer b, [int offset = 0]);

  /// Encode a JavaScript value into a Buffer.
  ///
  /// @param {(Number|Array|Object)} src - the value to be encoded into
  /// the buffer.  The type accepted depends on the (sub-)type of {@link
  /// Layout}.
  ///
  /// @param {Buffer} b - the buffer into which encoded data will be
  /// written.
  ///
  /// @param {Number} [offset] - the offset at which the encoded data
  /// starts.  If absent a zero offset is inferred.
  ///
  /// @returns {Number} - the number of bytes encoded, including the
  /// space skipped for internal padding, but excluding data such as
  /// {@link Sequence#count|lengths} when stored {@link
  /// ExternalLayout|externally}.  This is the adjustment to `offset`
  /// producing the offset where data for the next layout would be
  /// written.
  ///
  /// @abstract
  int encode(final T src, final Buffer b, [int offset = 0]);

  /// Calculate the span of a specific instance of a layout.
  ///
  /// @param {Buffer} b - the buffer that contains an encoded instance.
  ///
  /// @param {Number} [offset] - the offset at which the encoded instance
  /// starts.  If absent a zero offset is inferred.
  ///
  /// @return {Number} - the number of bytes covered by the layout
  /// instance.  If this method is not overridden in a subclass the
  /// definition-time constant {@link Layout#span|span} will be
  /// returned.
  ///
  /// @throws {RangeError} - if the length of the value cannot be
  /// determined.
  int getSpan(final Buffer b, [int offset = 0]) {
    check(span >= 0, 'indeterminate span.');
    return span;
  }

  /// Replicate the layout using a new property.
  ///
  /// This function must be used to get a structurally-equivalent layout
  /// with a different name since all {@link Layout} instances are
  /// immutable.
  ///
  /// **NOTE** This is a shallow copy.  All fields except {@link
  /// Layout#property|property} are strictly equal to the origin layout.
  ///
  /// @param {String} property - the value for {@link
  /// Layout#property|property} in the replica.
  ///
  /// @returns {Layout} - the copy with {@link Layout#property|property}
  /// set to `property`.
  Layout replicate(final String property);

  /// Create an object from layout properties and an array of values.
  ///
  /// **NOTE** This function returns `undefined` if invoked on a layout
  /// that does not return its value as an Object.  Objects are
  /// returned for things that are a {@link Structure}, which includes
  /// {@link VariantLayout|variant layouts} if they are structures, and
  /// excludes {@link Union}s.  If you want this feature for a union
  /// you must use {@link Union.getVariant|getVariant} to select the
  /// desired layout.
  ///
  /// @param {Array} values - an array of values that correspond to the
  /// default order for properties.  As with {@link Layout#decode|decode}
  /// layout elements that have no property name are skipped when
  /// iterating over the array values.  Only the top-level properties are
  /// assigned; arguments are not assigned to properties of contained
  /// layouts.  Any unused values are ignored.
  ///
  /// @return {(Object|undefined)}
  Map<String, dynamic>? fromArray(final List<dynamic> values) => null;
}


/// External Layout
/// ------------------------------------------------------------------------------------------------

abstract class ExternalLayout<T> extends Layout<T> {

  /// An object that behaves like a layout but does not consume space
  /// within its containing layout.
  ///
  /// This is primarily used to obtain metadata about a member, such as a
  /// {@link OffsetLayout} that can provide data about a {@link
  /// Layout#getSpan|value-specific span}.
  ///
  /// **NOTE** This is an abstract base class; you can create instances
  /// if it amuses you, but they won't support {@link
  /// ExternalLayout#isCount|isCount} or other {@link Layout} functions.
  ///
  /// @param {Number} span - initialiser for {@link Layout#span|span}.
  /// The parameter can range from 1 through 6.
  ///
  /// @param {string} [property] - initialiser for {@link
  /// Layout#property|property}.
  ///
  /// @abstract
  /// @augments {Layout}
  const ExternalLayout(final int span, final String? property)
    : super(span, property);
  
  /// Return `true` iff the external layout decodes to an unsigned
  /// integer layout.
  ///
  /// In that case it can be used as the source of {@link
  /// Sequence#count|Sequence counts}, {@link Blob#length|Blob lengths},
  /// or as {@link UnionLayoutDiscriminator#layout|external union
  /// discriminators}.
  ///
  /// @abstract
  bool isCount();
}


/// Greedy Count
/// ------------------------------------------------------------------------------------------------

class GreedyCount extends ExternalLayout<int> {

  /// An {@link ExternalLayout} that determines its {@link
  /// Layout#decode|value} based on offset into and length of the buffer
  /// on which it is invoked.
  ///
  /// *Factory*: {@link module:Layout.greedy|greedy}
  ///
  /// @param {Number} [elementSpan] - initialiser for {@link
  /// GreedyCount#elementSpan|elementSpan}.
  ///
  /// @param {string} [property] - initialiser for {@link
  /// Layout#property|property}.
  ///
  /// @augments {ExternalLayout}
  GreedyCount(final int? elementSpan, final String? property)
    : assert(elementSpan == null || elementSpan >= 0, 
      '[GreedyCount] elementSpan must be a (positive) integer'),
      elementSpan = elementSpan ?? 1,
      super(-1, property);

  /// The layout for individual elements of the sequence.  The value 
  /// must be a positive integer. If not provided, the value will be 1. 
  final int elementSpan;

  @override
  bool isCount() => true;

  @override
  int decode(final Buffer b, [int offset = 0]) {
    final int rem = b.length - offset;
    return (rem ~/ elementSpan).floor();
  }

  @override
  int encode(final int src, final Buffer b, [int offset = 0]) => 0;
  
  @override
  GreedyCount replicate(final String property) => GreedyCount(elementSpan, property);
}


/// Offset Layout
/// ------------------------------------------------------------------------------------------------

class OffsetLayout<T> extends ExternalLayout<T> {

  /// An {@link ExternalLayout} that supports accessing a {@link Layout}
  /// at a fixed offset from the start of another Layout.  The offset may
  /// be before, within, or after the base layout.
  ///
  /// *Factory*: {@link module:Layout.offset|offset}
  ///
  /// @param {Layout} layout - initialiser for {@link
  /// OffsetLayout#layout|layout}, modulo `property`.
  ///
  /// @param {Number} [offset] - Initialises {@link
  /// OffsetLayout#offset|offset}.  Defaults to zero.
  ///
  /// @param {string} [property] - Optional new property name for a
  /// {@link Layout#replicate| replica} of `layout` to be used as {@link
  /// OffsetLayout#layout|layout}.  If not provided the `layout` is used
  /// unchanged.
  ///
  /// @augments {Layout}
  OffsetLayout(this.layout, [final int? offset, final String? property])
    : offset = offset ?? 0,
      super(layout.span, property ?? layout.property);

  /// The subordinated layout.
  final Layout<T> layout;

  /// The location of {@link OffsetLayout#layout} relative to the
  /// start of another layout.
  /// 
  /// The value may be positive or negative, but an error will thrown
  /// if at the point of use it goes outside the span of the Buffer
  /// being accessed.
  final int offset;

  @override
  bool isCount() {
    return (layout is UInt) || (layout is UIntBE);
  }

  @override
  T decode(final Buffer b, [int offset = 0]) {
    return layout.decode(b, offset + this.offset);
  }

  @override
  int encode(final T src, final Buffer b, [int offset = 0]) {
    return layout.encode(src, b, offset + this.offset);
  }
  
  @override
  OffsetLayout replicate(final String property) => OffsetLayout(layout, offset, property);
}


/// UInt Layout
/// ------------------------------------------------------------------------------------------------

class UInt extends Layout<int> {

  /// Represent an unsigned integer in little-endian format.
  ///
  /// *Factory*: {@link module:Layout.u8|u8}, {@link
  ///  module:Layout.u16|u16}, {@link module:Layout.u24|u24}, {@link
  ///  module:Layout.u32|u32}, {@link module:Layout.u40|u40}, {@link
  ///  module:Layout.u48|u48}
  ///
  /// @param {Number} span - initialiser for {@link Layout#span|span}.
  /// The parameter can range from 1 through 6.
  ///
  /// @param {string} [property] - initialiser for {@link
  /// Layout#property|property}.
  ///
  /// @augments {Layout}
  const UInt(int span, String? property)
    : assert(span <= 6, 'span must not exceed 6 bytes'),
      super(span, property);

  @override
  int decode(final Buffer b, [int offset = 0]) {
    return b.getUint(offset, span, Endian.little);
  }

  @override
  int encode(final int src, final Buffer b, [int offset = 0]) {
    b.setUint(src, offset, span, Endian.little);
    return span;
  }
  
  @override
  UInt replicate(final String property) => UInt(span, property);
}


/// UIntBE Layout
/// ------------------------------------------------------------------------------------------------

class UIntBE extends Layout<int> {

  /// Represent an unsigned integer in big-endian format.
  ///
  /// *Factory*: {@link module:Layout.u8be|u8be}, {@link
  /// module:Layout.u16be|u16be}, {@link module:Layout.u24be|u24be},
  /// {@link module:Layout.u32be|u32be}, {@link
  /// module:Layout.u40be|u40be}, {@link module:Layout.u48be|u48be}
  ///
  /// @param {Number} span - initialiser for {@link Layout#span|span}.
  /// The parameter can range from 1 through 6.
  ///
  /// @param {string} [property] - initialiser for {@link
  /// Layout#property|property}.
  ///
  /// @augments {Layout}
  const UIntBE(final int span, final String? property)
    : assert(span <= 6, 'span must not exceed 6 bytes'),
      super(span, property);

  @override
  int decode(final Buffer b, [int offset = 0]) {
    return b.getUint(offset, span, Endian.big);
  }

  @override
  int encode(final int src, final Buffer b, [int offset = 0]) {
    b.setUint(src, offset, span, Endian.big);
    return span;
  }
  
  @override
  UIntBE replicate(final String property) => UIntBE(span, property);
}


/// Int
/// ------------------------------------------------------------------------------------------------

class Int extends Layout<int> {

  /// Represent a signed integer in little-endian format.
  ///
  /// *Factory*: {@link module:Layout.s8|s8}, {@link
  ///  module:Layout.s16|s16}, {@link module:Layout.s24|s24}, {@link
  ///  module:Layout.s32|s32}, {@link module:Layout.s40|s40}, {@link
  ///  module:Layout.s48|s48}
  ///
  /// @param {Number} span - initialiser for {@link Layout#span|span}.
  /// The parameter can range from 1 through 6.
  ///
  /// @param {string} [property] - initialiser for {@link
  /// Layout#property|property}.
  ///
  /// @augments {Layout}
  const Int(final int span, final String? property)
    : assert(span <= 6, 'span must not exceed 6 bytes'),
      super(span, property);

  @override
  int decode(final Buffer b, [int offset = 0]) {
    return b.getInt(offset, span, Endian.little);
  }

  @override
  int encode(final int src, final Buffer b, [int offset = 0]) {
    b.setInt(src, offset, span, Endian.little);
    return span;
  }
  
  @override
  Int replicate(final String property) => Int(span, property);
}


/// IntBE
/// ------------------------------------------------------------------------------------------------

class IntBE extends Layout<int> {

  /// Represent a signed integer in big-endian format.
  ///
  /// *Factory*: {@link module:Layout.s8be|s8be}, {@link
  /// module:Layout.s16be|s16be}, {@link module:Layout.s24be|s24be},
  /// {@link module:Layout.s32be|s32be}, {@link
  /// module:Layout.s40be|s40be}, {@link module:Layout.s48be|s48be}
  ///
  /// @param {Number} span - initialiser for {@link Layout#span|span}.
  /// The parameter can range from 1 through 6.
  ///
  /// @param {string} [property] - initialiser for {@link
  /// Layout#property|property}.
  ///
  /// @augments {Layout}
  const IntBE(final int span, final String? property)
    : assert(span <= 6, 'span must not exceed 6 bytes'),
      super(span, property);

  @override
  int decode(final Buffer b, [int offset = 0]) {
    return b.getInt(offset, span, Endian.big);
  }

  @override
  int encode(final int src, final Buffer b, [int offset = 0]) {
    b.setInt(src, offset, span, Endian.big);
    return span;
  }
  
  @override
  IntBE replicate(final String property) => IntBE(span, property);
}


/// Near UInt64
/// ------------------------------------------------------------------------------------------------

class NearUInt64 extends Layout<BigInt> {

  /// Represent an unsigned 64-bit integer in little-endian format when
  /// encoded and as a near integral JavaScript Number when decoded.
  ///
  /// *Factory*: {@link module:Layout.nu64|nu64}
  ///
  /// **NOTE** Values with magnitude greater than 2^52 may not decode to
  /// the exact value of the encoded representation.
  ///
  /// @augments {Layout}
  const NearUInt64(final String? property)
    : super(8, property);
    
  @override
  BigInt decode(final Buffer b, [int offset = 0]) {
    return b.getUint64(offset, Endian.little);
  }

  @override
  int encode(final BigInt src, final Buffer b, [int offset = 0]) {
    b.setUint64(src, offset, Endian.little);
    return span;
  }
  
  @override
  NearUInt64 replicate(final String property) => NearUInt64(property);
}


/// Near UInt64 BE
/// ------------------------------------------------------------------------------------------------

class NearUInt64BE extends Layout<BigInt> {

  /// Represent an unsigned 64-bit integer in big-endian format when
  /// encoded and as a near integral JavaScript Number when decoded.
  ///
  /// *Factory*: {@link module:Layout.nu64be|nu64be}
  ///
  /// **NOTE** Values with magnitude greater than 2^52 may not decode to
  /// the exact value of the encoded representation.
  ///
  /// @augments {Layout}
  const NearUInt64BE(final String? property)
    : super(8, property);
    
  @override
  BigInt decode(final Buffer b, [int offset = 0]) {
    return b.getUint64(offset, Endian.big);
  }

  @override
  int encode(final BigInt src, final Buffer b, [int offset = 0]) {
    b.setUint64(src, offset, Endian.big);
    return span;
  }
  
  @override
  NearUInt64BE replicate(final String property) => NearUInt64BE(property);
}


/// Near Int64
/// ------------------------------------------------------------------------------------------------

class NearInt64 extends Layout<int> {

  /// Represent a signed 64-bit integer in little-endian format when
  /// encoded and as a near integral JavaScript Number when decoded.
  ///
  /// *Factory*: {@link module:Layout.ns64|ns64}
  ///
  /// **NOTE** Values with magnitude greater than 2^52 may not decode to
  /// the exact value of the encoded representation.
  ///
  /// @augments {Layout}
  const NearInt64(final String? property)
    : super(8, property);

  @override
  int decode(final Buffer b, [int offset = 0]) {
    return b.getInt64(offset, Endian.little);
  }

  @override
  int encode(final int src, final Buffer b, [int offset = 0]) {
    b.setInt64(src, offset, Endian.little);
    return span;
  }
  
  @override
  NearInt64 replicate(final String property) => NearInt64(property);
}


/// Near Int64 BE
/// ------------------------------------------------------------------------------------------------

class NearInt64BE extends Layout<int> {

  /// Represent a signed 64-bit integer in big-endian format when
  /// encoded and as a near integral JavaScript Number when decoded.
  ///
  /// *Factory*: {@link module:Layout.ns64be|ns64be}
  ///
  /// **NOTE** Values with magnitude greater than 2^52 may not decode to
  /// the exact value of the encoded representation.
  ///
  /// @augments {Layout}
  const NearInt64BE(final String? property)
    : super(8, property);

  @override
  int decode(final Buffer b, [int offset = 0]) {
    return b.getInt64(offset, Endian.big);
  }

  @override
  int encode(final int src, final Buffer b, [int offset = 0]) {
    b.setInt64(src, offset, Endian.big);
    return span;
  }
  
  @override
  NearInt64BE replicate(final String property) => NearInt64BE(property);
}


/// Float
/// ------------------------------------------------------------------------------------------------

class Float extends Layout<double> {

  /// Represent a 32-bit floating point number in little-endian format.
  ///
  /// *Factory*: {@link module:Layout.f32|f32}
  ///
  /// @param {string} [property] - initialiser for {@link
  /// Layout#property|property}.
  ///
  /// @augments {Layout}
  const Float(final String? property)
    : super(4, property);

  @override
  double decode(final Buffer b, [int offset = 0]) {
    return b.getFloat32(offset, Endian.little);
  }

  @override
  int encode(final double src, final Buffer b, [int offset = 0]) {
    b.setFloat32(src, offset, Endian.little);
    return span;
  }
  
  @override
  Float replicate(final String property) => Float(property);
}


/// Float BE
/// ------------------------------------------------------------------------------------------------

class FloatBE extends Layout<double> {

  /// Represent a 32-bit floating point number in big-endian format.
  ///
  /// *Factory*: {@link module:Layout.f32be|f32be}
  ///
  /// @param {string} [property] - initialiser for {@link
  /// Layout#property|property}.
  ///
  /// @augments {Layout}
  const FloatBE(final String? property)
    : super(4, property);

  @override
  double decode(final Buffer b, [int offset = 0]) {
    return b.getFloat32(offset, Endian.big);
  }

  @override
  int encode(final double src, final Buffer b, [int offset = 0]) {
    b.setFloat32(src, offset, Endian.big);
    return span;
  }
  
  @override
  FloatBE replicate(final String property) => FloatBE(property);
}


/// Double
/// ------------------------------------------------------------------------------------------------

class Double extends Layout<double> {

  /// Represent a 64-bit floating point number in little-endian format.
  ///
  /// *Factory*: {@link module:Layout.f64|f64}
  ///
  /// @param {string} [property] - initialiser for {@link
  /// Layout#property|property}.
  ///
  /// @augments {Layout}
  const Double(final String? property)
    : super(8, property);

  @override
  double decode(final Buffer b, [int offset = 0]) {
    return b.getFloat64(offset, Endian.little);
  }

  @override
  int encode(final double src, final Buffer b, [int offset = 0]) {
    b.setFloat64(src, offset, Endian.little);
    return span;
  }
  
  @override
  Double replicate(final String property) => Double(property);
}


/// Double BE
/// ------------------------------------------------------------------------------------------------

class DoubleBE extends Layout<double> {

  /// Represent a 64-bit floating point number in big-endian format.
  ///
  /// *Factory*: {@link module:Layout.f64be|f64be}
  ///
  /// @param {string} [property] - initialiser for {@link
  /// Layout#property|property}.
  ///
  /// @augments {Layout}
  const DoubleBE(final String? property)
    : super(8, property);

  @override
  double decode(final Buffer b, [int offset = 0]) {
    return b.getFloat64(offset, Endian.big);
  }

  @override
  int encode(final double src, final Buffer b, [int offset = 0]) {
    b.setFloat64(src, offset, Endian.big);
    return span;
  }
  
  @override
  DoubleBE replicate(final String property) => DoubleBE(property);
}


/// Sequence
/// ------------------------------------------------------------------------------------------------

class Sequence<T> extends Layout<Iterable<T>> {

  /// Represent a contiguous sequence of a specific layout as an Array.
  ///
  /// *Factory*: {@link module:Layout.seq|seq}
  ///
  /// @param {Layout} elementLayout - initialiser for {@link 
  /// Sequence#elementLayout|elementLayout}.
  ///
  /// @param {(Number|ExternalLayout)} count - initialiser for {@link
  /// Sequence#count|count}.  The parameter must be either a positive
  /// integer or an instance of {@link ExternalLayout}.
  /// 
  /// @param {string} [property] - initialiser for {@link
  /// Layout#property|property}.
  /// 
  /// @augments {Layout}
  Sequence(this.elementLayout, this.count, String? property)
    : assert((count is ExternalLayout && count.isCount()) || (count is int && count >= 0),
      'count must be non-negative integer or an unsigned integer ExternalLayout'),
      super(count is! ExternalLayout && elementLayout.span > 0 
              ? (count as int) * elementLayout.span 
              : -1, property);
  
  /// The layout for individual elements of the sequence.
  final Layout<T> elementLayout;

  /// The number of elements in the sequence.
  ///
  /// This will be either a non-negative integer or an instance of
  /// {@link ExternalLayout} for which {@link
  /// ExternalLayout#isCount|isCount()} is `true`.
  final dynamic count;

  /// Normalise [count] to an integer value.
  int normaliseCount(final Buffer b, [int offset = 0]) {
    final dynamic count = this.count;
    return count is ExternalLayout ? count.decode(b, offset) : count;
  }

  @override
  int getSpan(final Buffer b, [int offset = 0]) {
    if (this.span >= 0) {
      return this.span;
    }
    int span = 0;
    final int count = normaliseCount(b, offset);
    if (elementLayout.span > 0) {
      span = count * elementLayout.span;
    } else {
      for (int i = 0; i < count; ++i) {
        span += elementLayout.getSpan(b, offset + span);
      }
    }
    return span;
  }

  @override
  Iterable<T> decode(final Buffer b, [int offset = 0]) {
    final List<T> rv = [];
    final int count = normaliseCount(b, offset);
    for (int i = 0; i < count; ++i) {
      rv.add(elementLayout.decode(b, offset));
      offset += elementLayout.getSpan(b, offset);
    }
    return rv;
  }

  /// Implement {@link Layout#encode|encode} for {@link Sequence}.
  ///
  /// **NOTE** If `src` is shorter than {@link Sequence#count|count} then
  /// the unused space in the buffer is left unchanged.  If `src` is
  /// longer than {@link Sequence#count|count} the unneeded elements are
  /// ignored.
  ///
  /// **NOTE** If {@link Layout#count|count} is an instance of {@link
  /// ExternalLayout} then the length of `src` will be encoded as the
  /// count after `src` is encoded.
  @override
  int encode(final Iterable<T> src, final Buffer b, [int offset = 0]) {
    final Layout<T> elo = elementLayout;
    final int span = src.fold(0, (final int span, final T item) {
      return span + elo.encode(item, b, offset + span);
    });
    if (count is ExternalLayout) {
      (count as ExternalLayout).encode(src.length, b, offset);
    }
    return span;
  }
  
  @override
  Sequence<T> replicate(final String property) => Sequence<T>(elementLayout, count, property);
}


/// Structure Layout
/// ------------------------------------------------------------------------------------------------

abstract class StructureLayout<T, U> extends Layout<T> {
  
  const StructureLayout(this.fields, super.span, super.property);

  /// The sequence of {@link Layout} values that comprise the
  /// structure.
  ///
  /// The individual elements need not be the same type, and may be
  /// either scalar or aggregate layouts.  If a member layout leaves
  /// its {@link Layout#property|property} undefined the
  /// corresponding region of the buffer associated with the element
  /// will not be mutated.
  ///
  /// @type {Layout[]}
  final List<U> fields;
}


/// Structure
/// ------------------------------------------------------------------------------------------------

class Structure extends StructureLayout<dynamic, Layout> {

  /// Represent a contiguous sequence of arbitrary layout elements as an
  /// Object.
  ///
  /// *Factory*: {@link module:Layout.struct|struct}
  ///
  /// **NOTE** The {@link Layout#span|span} of the structure is variable
  /// if any layout in {@link Structure#fields|fields} has a variable
  /// span.  When {@link Layout#encode|encoding} we must have a value for
  /// all variable-length fields, or we wouldn't be able to figure out
  /// how much space to use for storage.  We can only identify the value
  /// for a field when it has a {@link Layout#property|property}.  As
  /// such, although a structure may contain both unnamed fields and
  /// variable-length fields, it cannot contain an unnamed
  /// variable-length field.
  ///
  /// @param {Layout[]} fields - initialiser for {@link
  /// Structure#fields|fields}.  An error is raised if this contains a
  /// variable-length field for which a {@link Layout#property|property}
  /// is not defined.
  ///
  /// @param {string} [property] - initialiser for {@link
  /// Layout#property|property}.
  ///
  /// @param {Boolean} [decodePrefixes] - initialiser for {@link
  /// Structure#decodePrefixes|property}.
  ///
  /// @throws {Error} - if `fields` contains an unnamed variable-length
  /// layout.
  ///
  /// @augments {Layout}
  Structure(final List<Layout> fields, final String? property, final bool? decodePrefixes)
    : decodePrefixes = decodePrefixes ?? false,
      super(fields, _initSpan(fields), property);

  /// Validate the [fields]' items and return the sum of the [fields]' [span] values.
  static int _initSpan(final Iterable<Layout> fields) {
    try {
      final Buffer b = Buffer.fromList([]);
      return fields.fold(0, (int span, Layout fd) {
        /// Verify absence of unnamed variable-length fields.
        if (fd.property == null && fd.span < 0) {
          throw const FormatException('fields cannot contain unnamed variable-length layout');
        }
        return span + fd.getSpan(b);
      });
    } on FormatException catch (_) {
      rethrow;
    } catch (_) {
      return -1;
    }
  }

  /// Control behavior of {@link Layout#decode|decode()} given short
  /// buffers.
  ///
  /// In some situations a structure many be extended with additional
  /// fields over time, with older installations providing only a
  /// prefix of the full structure.  If this property is `true`
  /// decoding will accept those buffers and leave subsequent fields
  /// undefined, as long as the buffer ends at a field boundary.
  /// Defaults to `false`.
  final bool decodePrefixes;

  @override
  int getSpan(final Buffer b, [int offset = 0]) {
    if (span >= 0) {
      return span;
    }
    try {
      return fields.fold(0, (int span, Layout fd) {
        final int fsp = fd.getSpan(b, offset);
        offset += fsp;
        return span + fsp;
      });
    } catch (e) {
      throw RangeError('indeterminate span');
    }
  }

  @override
  dynamic decode(final Buffer b, [int offset = 0]) {
    final dest = makeDestinationObject();
    for (final Layout fd in fields) {
      final String? property = fd.property;
      if (property != null) {
        dest[property] = fd.decode(b, offset);
      }
      offset += fd.getSpan(b, offset);
      if (decodePrefixes && (b.length == offset)) {
        break;
      }
    }
    return dest;
  }

  /// Implement {@link Layout#encode|encode} for {@link Structure}.
  ///
  /// If `src` is missing a property for a member with a defined {@link
  /// Layout#property|property} the corresponding region of the buffer is
  /// left unmodified.
  @override
  int encode(final dynamic src, final Buffer b, [int offset = 0]) {
    src as Map<String, dynamic>;
    final int firstOffset = offset;
    int lastOffset = 0;
    int lastWrote = 0;
    for (final Layout fd in fields) {
      int span = fd.span;
      lastWrote = (span > 0) ? span : 0;
      final String? property = fd.property;
      if (property != null) {
        final fv = src[property];
        if (fv != null) {
          lastWrote = fd.encode(fv, b, offset);
          if (span < 0) {
            /// Read the as-encoded span, which is not necessarily the
            /// same as what we wrote.
            span = fd.getSpan(b, offset);
          }
        }
      }
      lastOffset = offset;
      offset += span;
    }

    /// Use (lastOffset + lastWrote) instead of offset because the last
    /// item may have had a dynamic length and we don't want to include
    /// the padding between it and the end of the space reserved for
    /// it.
    return (lastOffset + lastWrote) - firstOffset;
  }

  @override
  Map<String, dynamic>? fromArray(final List values) {
    final dest = makeDestinationObject();
    for (final Layout fd in fields) {
      final String? property = fd.property;
      if (property != null && values.isNotEmpty) {
        dest[property] = values.removeAt(0);
      }
    }
    return dest;
  }

  /// Get access to the layout of a given property.
  ///
  /// @param {String} property - the structure member of interest.
  ///
  /// @return {Layout} - the layout associated with `property`, or
  /// undefined if there is no such property.
  Layout? layoutFor(final String property) {
    for (final Layout fd in fields) {
      if (fd.property == property) {
        return fd;
      }
    }
    return null;
  }

  /// Get the offset of a structure member.
  ///
  /// @param {String} property - the structure member of interest.
  ///
  /// @return {Number} - the offset in bytes to the start of `property`
  /// within the structure, or undefined if `property` is not a field
  /// within the structure.  If the property is a member but follows a
  /// variable-length structure member a negative number will be
  /// returned.
  int? offsetOf(final String property) {
    int offset = 0;
    for (final Layout fd in fields) {
      if (fd.property == property) {
        return offset;
      }
      if (fd.span < 0) {
        offset = -1;
      } else if (offset >= 0) {
        offset += fd.span;
      }
    }
    return null;
  }
  
  @override
  Structure replicate(final String property) => Structure(fields, property, decodePrefixes);
}


/// Rust String
/// ------------------------------------------------------------------------------------------------

class RustString extends Structure {
  
  /// Represents a Rust String.
  RustString(super.fields, super.property, super.decodePrefixes);

  /// Returns the number of bytes needed to represent [value] as a rust string.
  int alloc(final String value) {
    return u32().span + u32().span + Buffer.fromString(value).length;
  }

  @override
  String decode(Buffer b, [int offset = 0]) {
    final Map<String, dynamic> data = super.decode(b, offset);
    return data['chars'].encode(BufferEncoding.utf8);
  }

  @override
  int encode(final dynamic src, final Buffer b, [int offset = 0]) {
    final Map<String, dynamic> data = { 'chars': Buffer.fromString(src as String) };
    return super.encode(data, b, offset);
  }

  @override
  RustString replicate(final String property) => RustString(fields, property, decodePrefixes);
}


/// Union Discriminator
/// ------------------------------------------------------------------------------------------------

abstract class UnionDiscriminator<T> {

  /// An object that can provide a {@link
  /// Union#discriminator|discriminator} API for {@link Union}.
  ///
  /// **NOTE** This is an abstract base class; you can create instances
  /// if it amuses you, but they won't support the {@link
  /// UnionDiscriminator#encode|encode} or {@link
  /// UnionDiscriminator#decode|decode} functions.
  ///
  /// @param {string} [property] - Default for {@link
  /// UnionDiscriminator#property|property}.
  ///
  /// @abstract
  const UnionDiscriminator(this.property);

  /// The {@link Layout#property|property} to be used when the
  /// discriminator is referenced in isolation (generally when {@link
  /// Union#decode|Union decode} cannot delegate to a specific
  /// variant). 
  final String property;

  /// Analog to {@link Layout#decode|Layout decode} for union discriminators.
  ///
  /// The implementation of this method need not reference the buffer if
  /// variant information is available through other means.
  T decode(final Buffer b, [int offset = 0]);

  /// Analog to {@link Layout#decode|Layout encode} for union discriminators.
  ///
  /// The implementation of this method need not store the value if
  /// variant information is maintained through other means.
  int encode(final T src, final Buffer b, [int offset = 0]);
}


/// Union Layout Discriminator
/// ------------------------------------------------------------------------------------------------

class UnionLayoutDiscriminator<T> extends UnionDiscriminator<T> {

  /// An object that can provide a {@link
  /// UnionDiscriminator|discriminator API} for {@link Union} using an
  /// unsigned integral {@link Layout} instance located either inside or
  /// outside the union.
  ///
  /// @param {ExternalLayout} layout - initialises {@link
  /// UnionLayoutDiscriminator#layout|layout}.  Must satisfy {@link
  /// ExternalLayout#isCount|isCount()}.
  ///
  /// @param {string} [property] - Default for {@link
  /// UnionDiscriminator#property|property}, superseding the property
  /// from `layout`, but defaulting to `variant` if neither `property`
  /// nor layout provide a property name.
  ///
  /// @augments {UnionDiscriminator}
  UnionLayoutDiscriminator(this.layout, [String? property]) 
    : assert(layout.isCount(), 'layout must be an unsigned integer ExternalLayout'),
      super(property ?? layout.property ?? 'variant');

  /// The {@link ExternalLayout} used to access the discriminator value.
  final ExternalLayout<T> layout;

  /// Delegate decoding to {@link UnionLayoutDiscriminator#layout|layout}.
  @override
  T decode(final Buffer b, [int offset = 0]) {
    return layout.decode(b, offset);
  }

  /// Delegate encoding to {@link UnionLayoutDiscriminator#layout|layout}.
  @override
  int encode(final T src, final Buffer b, [int offset = 0]) {
    return layout.encode(src, b, offset);
  }
}


/// Union
/// ------------------------------------------------------------------------------------------------

typedef _GetSourceVariant = VariantLayout? Function(Map<String, dynamic> src);
typedef GetSourceVariant = VariantLayout? Function(Map<String, dynamic> src, Union instance);

class Union extends Layout<Map<String, dynamic>> {

  /// Represent any number of span-compatible layouts.
  ///
  /// *Factory*: {@link module:Layout.union|union}
  ///
  /// If the union has a {@link Union#defaultLayout|default layout} that
  /// layout must have a non-negative {@link Layout#span|span}.  The span
  /// of a fixed-span union includes its {@link
  /// Union#discriminator|discriminator} if the variant is a {@link
  /// Union#usesPrefixDiscriminator|prefix of the union}, plus the span
  /// of its {@link Union#defaultLayout|default layout}.
  ///
  /// If the union does not have a default layout then the encoded span
  /// of the union depends on the encoded span of its variant (which may
  /// be fixed or variable).
  ///
  /// {@link VariantLayout#layout|Variant layout}s are added through
  /// {@link Union#addVariant|addVariant}.  If the union has a default
  /// layout, the span of the {@link VariantLayout#layout|layout
  /// contained by the variant} must not exceed the span of the {@link
  /// Union#defaultLayout|default layout} (minus the span of a {@link
  /// Union#usesPrefixDiscriminator|prefix disriminator}, if used).  The
  /// span of the variant will equal the span of the union itself.
  ///
  /// The variant for a buffer can only be identified from the {@link
  /// Union#discriminator|discriminator} {@link
  /// UnionDiscriminator#property|property} (in the case of the {@link
  /// Union#defaultLayout|default layout}), or by using {@link
  /// Union#getVariant|getVariant} and examining the resulting {@link
  /// VariantLayout} instance.
  ///
  /// A variant compatible with a JavaScript object can be identified
  /// using {@link Union#getSourceVariant|getSourceVariant}.
  ///
  /// @param {(UnionDiscriminator|ExternalLayout|Layout)} discr - How to
  /// identify the layout used to interpret the union contents.  The
  /// parameter must be an instance of {@link UnionDiscriminator}, an
  /// {@link ExternalLayout} that satisfies {@link
  /// ExternalLayout#isCount|isCount()}, or {@link UInt} (or {@link
  /// UIntBE}).  When a non-external layout element is passed the layout
  /// appears at the start of the union.  In all cases the (synthesised)
  /// {@link UnionDiscriminator} instance is recorded as {@link
  /// Union#discriminator|discriminator}.
  ///
  /// @param {(Layout|null)} defaultLayout - initialiser for {@link
  /// Union#defaultLayout|defaultLayout}.  If absent defaults to `null`.
  /// If `null` there is no default layout: the union has data-dependent
  /// length and attempts to decode or encode unrecognised variants will
  /// throw an exception.  A {@link Layout} instance must have a
  /// non-negative {@link Layout#span|span}, and if it lacks a {@link
  /// Layout#property|property} the {@link
  /// Union#defaultLayout|defaultLayout} will be a {@link
  /// Layout#replicate|replica} with property `content`.
  ///
  /// @param {string} [property] - initialiser for {@link
  /// Layout#property|property}.
  ///
  /// @augments {Layout}
  Union(
    this.discriminator, 
    this.usesPrefixDiscriminator, 
    this.defaultLayout, 
    final int span,
    final String? property,
  ):  super(span, property);

  /// Create an instance of [Union].
  factory Union.constructor(
    dynamic discr, [
    Layout? defaultLayout, 
    final String? property,
  ]) {
    
    final bool upv = (discr is UInt) || (discr is UIntBE);
    
    if (upv) {
      discr = UnionLayoutDiscriminator(OffsetLayout(discr));
    } else if (discr is ExternalLayout && discr.isCount()) {
      discr = UnionLayoutDiscriminator(discr);
    } else if (discr is! UnionDiscriminator) {
      throw Exception('discr must be a UnionDiscriminator or an unsigned integer layout');
    }
    
    if (defaultLayout != null) {
      if (defaultLayout.span < 0) {
        throw RangeError('defaultLayout must have constant span');
      }
      if (defaultLayout.property == null) {
        defaultLayout = defaultLayout.replicate('content');
      }
    }

    /// The union span can be estimated only if there's a default
    /// layout.  The union spans its default layout, plus any prefix
    /// variant layout.  By construction both layouts, if present, have
    /// non-negative span.
    int span = -1;
    if (defaultLayout != null) {
      span = defaultLayout.span;
      if (span >= 0 && upv) {
        span += discr.layout.span as int;
      }
    }

    return Union(discr, upv, defaultLayout, span, property);
  }

  /// The interface for the discriminator value in isolation.
  ///
  /// This a {@link UnionDiscriminator} either passed to the
  /// constructor or synthesised from the `discr` constructor
  /// argument.  {@link
  /// Union#usesPrefixDiscriminator|usesPrefixDiscriminator} will be
  /// `true` iff the `discr` parameter was a non-offset {@link
  /// Layout} instance.////
  final UnionDiscriminator discriminator;

  /// `true` if the {@link Union#discriminator|discriminator} is the
  /// first field in the union.
  ///
  /// If `false` the discriminator is obtained from somewhere
  /// else.
  final bool usesPrefixDiscriminator;

  /// The layout for non-discriminator content when the value of the
  /// discriminator is not recognised.
  ///
  /// This is the value passed to the constructor.  It is
  /// structurally equivalent to the second component of {@link
  /// Union#layout|layout} but may have a different property
  /// name.
  final Layout? defaultLayout;

  /// A registry of allowed variants.
  ///
  /// The keys are unsigned integers which should be compatible with
  /// {@link Union.discriminator|discriminator}.  The property value
  /// is the corresponding {@link VariantLayout} instances assigned
  /// to this union by {@link Union#addVariant|addVariant}.
  ///
  /// *NOTE** The registry remains mutable so that variants can be
  /// {@link Union#addVariant|added} at any time.  Users should not
  /// manipulate the content of this property.
  final Map<int, VariantLayout> registry = {};

  /// Private variable used when invoking getSourceVariant
  _GetSourceVariant? _boundGetSourceVariant;

  /// Function to infer the variant selected by a source object.
  ///
  /// Defaults to {@link
  /// Union#defaultGetSourceVariant|defaultGetSourceVariant} but may
  /// be overridden using {@link
  /// Union#configGetSourceVariant|configGetSourceVariant}.
  ///
  /// @param {Object} src - as with {@link
  /// Union#defaultGetSourceVariant|defaultGetSourceVariant}.
  ///
  /// @returns {(undefined|VariantLayout)} The default variant
  /// (`undefined`) or first registered variant that uses a property
  /// available in `src`.
  VariantLayout? getSourceVariant(final Map<String, dynamic> src) {
    return (_boundGetSourceVariant ?? defaultGetSourceVariant)(src);
  }

  /// Function to override the implementation of {@link
  /// Union#getSourceVariant|getSourceVariant}.
  ///
  /// Use this if the desired variant cannot be identified using the
  /// algorithm of {@link
  /// Union#defaultGetSourceVariant|defaultGetSourceVariant}.
  ///
  /// **NOTE** The provided function will be invoked bound to this
  /// Union instance, providing local access to {@link
  /// Union#registry|registry}.
  ///
  /// @param {Function} gsv - a function that follows the API of
  /// {@link Union#defaultGetSourceVariant|defaultGetSourceVariant}. */
  void configGetSourceVariant(final GetSourceVariant gsv) {
    _boundGetSourceVariant = (final Map<String, dynamic> src) => gsv(src, this);
  }

  /// Cast [discriminator] to a [UnionLayoutDiscriminator] if [usesPrefixDiscriminator] has been
  /// set.
  UnionLayoutDiscriminator? toLayoutDiscriminator([UnionDiscriminator? discriminator]) {
    return usesPrefixDiscriminator 
      ? (discriminator ?? this.discriminator) as UnionLayoutDiscriminator 
      : null;
  }

  @override
  int getSpan(final Buffer b, [int offset = 0]) {
    if (span >= 0) {
      return span;
    }
    /// Default layouts always have non-negative span, so we don't have
    /// one and we have to recognise the variant which will in turn
    /// determine the span.
    final VariantLayout? vlo = getVariant(b, offset);
    if (vlo == null) {
      throw Exception('unable to determine span for unrecognised variant');
    }
    return vlo.getSpan(b, offset);
  }

  /// Method to infer a registered Union variant compatible with `src`.
  ///
  /// The first satisified rule in the following sequence defines the
  /// return value:
  /// * If `src` has properties matching the Union discriminator and
  ///   the default layout, `undefined` is returned regardless of the
  ///   value of the discriminator property (this ensures the default
  ///   layout will be used);
  /// * If `src` has a property matching the Union discriminator, the
  ///   value of the discriminator identifies a registered variant, and
  ///   either (a) the variant has no layout, or (b) `src` has the
  ///   variant's property, then the variant is returned (because the
  ///   source satisfies the constraints of the variant it identifies);
  /// * If `src` does not have a property matching the Union
  ///   discriminator, but does have a property matching a registered
  ///   variant, then the variant is returned (because the source
  ///   matches a variant without an explicit conflict);
  /// * An error is thrown (because we either can't identify a variant,
  ///   or we were explicitly told the variant but can't satisfy it).
  ///
  /// @param {Object} src - an object presumed to be compatible with
  /// the content of the Union.
  ///
  /// @return {(undefined|VariantLayout)} - as described above.
  ///
  /// @throws {Error} - if `src` cannot be associated with a default or
  /// registered variant.
  VariantLayout? defaultGetSourceVariant(final Map<dynamic, dynamic> src) {
    if (src.containsKey(discriminator.property)) {
      final Layout? defaultLayout = this.defaultLayout;
      if (defaultLayout != null && src.containsKey(defaultLayout.property)) {
        return null;
      }
      final VariantLayout? vlo = registry[src[discriminator.property]];
      if (vlo != null && ((vlo.layout == null) || src.containsKey(vlo.property))) {
        return vlo;
      }
    } else {
      for (final VariantLayout vlo in registry.values) {
        if (src.containsKey(vlo.property)) {
          return vlo;
        }
      }
    }
    throw Exception('unable to infer src variant');
  }

  /// Implement {@link Layout#decode|decode} for {@link Union}.
  ///
  /// If the variant is {@link Union#addVariant|registered} the return
  /// value is an instance of that variant, with no explicit
  /// discriminator.  Otherwise the {@link Union#defaultLayout|default
  /// layout} is used to decode the content.
  @override
  Map<String, dynamic> decode(final Buffer b, [int offset = 0]) {
    Map<String, dynamic> dest;
    final UnionDiscriminator dlo = discriminator;
    final Layout? defaultLayout = this.defaultLayout;
    final discr = dlo.decode(b, offset);
    Layout? clo = registry[discr];
    if (clo == null) {
      dest = makeDestinationObject();
      dest[dlo.property] = discr;
      if (defaultLayout != null) {
        clo = defaultLayout;
        final int contentOffset = toLayoutDiscriminator(dlo)?.layout.span ?? 0;
        /// If [defaultLayout] is not null, its 'property' value will not be null. This is set to 
        /// 'content' by the [constructor] as a fallback property name.
        dest[clo.property ?? 'content'] = defaultLayout.decode(b, offset + contentOffset);
      }
    } else {
      dest = clo.decode(b, offset);
    }
    return dest;
  }

  /// Implement {@link Layout#encode|encode} for {@link Union}.
  ///
  /// This API assumes the `src` object is consistent with the union's
  /// {@link Union#defaultLayout|default layout}.  To encode variants
  /// use the appropriate variant-specific {@link VariantLayout#encode}
  /// method.
   @override
  int encode(final Map<String, dynamic> src, final Buffer b, [int offset = 0]) {
    final VariantLayout? vlo = getSourceVariant(src);
    if (vlo == null) {
      final UnionDiscriminator dlo = discriminator;
      final Layout? clo = defaultLayout;
      dlo.encode(src[dlo.property], b, offset);
      final int contentOffset = toLayoutDiscriminator(dlo)?.layout.span ?? 0;
      return contentOffset + (clo?.encode(src[clo.property], b, offset + contentOffset) ?? 0);
    }
    return vlo.encode(src, b, offset);
  }

  /// Register a new variant structure within a union.  The newly
  /// created variant is returned.
  ///
  /// @param {Number} variant - initialiser for {@link
  /// VariantLayout#variant|variant}.
  ///
  /// @param {Layout} layout - initialiser for {@link
  /// VariantLayout#layout|layout}.
  ///
  /// @param {String} property - initialiser for {@link
  /// Layout#property|property}.
  ///
  /// @return {VariantLayout} */
  VariantLayout addVariant(final int variant, final Layout layout, final String property) {
    final rv = VariantLayout.constructor(this, variant, layout, property);
    registry[variant] = rv;
    return rv;
  }

  /// Normalise [value] to an [int]. The type of [value] passed to this method must be an [int] or 
  /// [Buffer]. If [value] is a [Buffer], [offset] is the offset into the buffer and defaults to 0. 
  int _normaliseVariant(final dynamic value, int offset) {
    assert(value is int || value is Buffer);
    return value is Buffer ? discriminator.decode(value, offset) : value;
  }

  /// Get the layout associated with a registered variant.
  ///
  /// If `vb` does not produce a registered variant the function returns
  /// `undefined`.
  ///
  /// @param {(Number|Buffer)} vb - either the variant number, or a
  /// buffer from which the discriminator is to be read.
  ///
  /// @param {Number} offset - offset into `vb` for the start of the
  /// union.  Used only when `vb` is an instance of {Buffer}.
  ///
  /// @return {({VariantLayout}|undefined)}
  VariantLayout? getVariant(final dynamic vb, [int offset = 0]) {
    final int variant = _normaliseVariant(vb, offset);
    return registry[variant];
  }
  
  @override
  Union replicate(final String property) {
    return Union.constructor(discriminator, defaultLayout, property);
  }
}


/// Variant Layout
/// ------------------------------------------------------------------------------------------------

/// Represent a specific variant within a containing union.
///
/// **NOTE** The {@link Layout#span|span} of the variant may include
/// the span of the {@link Union#discriminator|discriminator} used to
/// identify it, but values read and written using the variant strictly
/// conform to the content of {@link VariantLayout#layout|layout}.
///
/// **NOTE** User code should not invoke this constructor directly.  Use
/// the union {@link Union#addVariant|addVariant} helper method.
///
/// @param {Union} union - initialiser for {@link
/// VariantLayout#union|union}.
///
/// @param {Number} variant - initialiser for {@link
/// VariantLayout#variant|variant}.
///
/// @param {Layout} [layout] - initialiser for {@link
/// VariantLayout#layout|layout}.  If absent the variant carries no
/// data.
///
/// @param {String} [property] - initialiser for {@link
/// Layout#property|property}.  Unlike many other layouts, variant
/// layouts normally include a property name so they can be identified
/// within their containing {@link Union}.  The property identifier may
/// be absent only if `layout` is is absent.
///
/// @augments {Layout}
class VariantLayout<T> extends Layout<Map<String, dynamic>> {

  const VariantLayout(
    this.union,
    this.variant,
    this.layout,
    int span,
    String? property,
  ): super(span, property);

  /// The {@link Union} to which this variant belongs.
  final Union union;

  /// The unsigned integral value identifying this variant within
  /// the {@link Union#discriminator|discriminator} of the containing
  /// union.
  final int variant;

  /// The {@link Layout} to be used when reading/writing the
  /// non-discriminator part of the {@link
  /// VariantLayout#union|union}.  If `null` the variant carries no
  /// data.
  final Layout<T>? layout;

  /// Create an instance of [Union].
  factory VariantLayout.constructor(
    final Union union, 
    final int variant, [
    final Layout<T>? layout, 
    final String? property,
  ]) {
    if (variant < 0) {
      throw RangeError('variant must be a (non-negative) integer');
    }
    final Layout? unionDefaultLayout = union.defaultLayout;
    if (layout != null) {
      if (unionDefaultLayout != null 
          && layout.span >= 0 
          && layout.span > unionDefaultLayout.span) {
        throw RangeError('variant span exceeds span of containing union');
      }
    }
    int span = union.span;
    if (union.span < 0) {
      span = layout?.span ?? 0;
      if (span >= 0 && union.usesPrefixDiscriminator) {
        span += union.toLayoutDiscriminator()?.layout.span ?? 0;
      }
    }

    return VariantLayout(union, variant, layout, span, property);
  }

  @override
  int getSpan(final Buffer b, [int offset = 0]) {
    if (span >= 0) {
      /// Will be equal to the containing union span if that is not
      /// variable.
      return span;
    }
    final int contentOffset = union.toLayoutDiscriminator()?.layout.span ?? 0;
    /// Span is defined solely by the variant (and prefix discriminator)
    return contentOffset + (layout?.getSpan(b, offset + contentOffset) ?? 0);
  }

  @override
  Map<String, dynamic> decode(final Buffer b, [int offset = 0]) {
    final dest = makeDestinationObject();
    if (union.getVariant(b, offset) != this) {
      throw Exception('variant mismatch');
    }
    final Layout? layout = this.layout;
    final String? property = this.property;
    if (property != null) {
      final int contentOffset = union.toLayoutDiscriminator()?.layout.span ?? 0;
      dest[property] = layout?.decode(b, offset + contentOffset) ?? true;
    } else if (union.usesPrefixDiscriminator) {
      dest[union.discriminator.property] = variant;
    }
    return dest;
  }

  @override
  int encode(final Map<String, dynamic> src, final Buffer b, [int offset = 0]) {
    final Layout? layout = this.layout;
    if (layout != null && !src.containsKey(property)) {
      throw Exception('variant lacks property $property');
    }
    union.discriminator.encode(variant, b, offset);
    final int contentOffset = union.toLayoutDiscriminator()?.layout.span ?? 0;
    int span = contentOffset;
    if (layout != null) {
      layout.encode(src[property], b, offset + contentOffset);
      span += layout.getSpan(b, offset + contentOffset);
      if (union.span >= 0 && span > union.span) {
        throw Exception('encoded variant overruns containing union');
      }
    }
    return span;
  }

  /// Delegate {@link Layout#fromArray|fromArray} to {@link
  /// VariantLayout#layout|layout}. */
  @override
  Map<String, dynamic>? fromArray(final List values) {
    return layout?.fromArray(values);
  }
  
  @override
  VariantLayout<T> replicate(final String property) {
    return VariantLayout<T>.constructor(union, variant, layout, property);
  }
}

/// JavaScript chose to define bitwise operations as operating on
/// signed 32-bit values in 2's complement form, meaning any integer
/// with bit 31 set is going to look negative.  For right shifts that's
/// not a problem, because `>>>` is a logical shift, but for every
/// other bitwise operator we have to compensate for possible negative
/// results. */
int fixBitwiseResult(final int v) => v; // v < 0 ? v + 0x100000000 : v;


/// Bit Structure
/// ------------------------------------------------------------------------------------------------

class BitStructure extends StructureLayout<Map<String, dynamic>, BitField> {

  /// Contain a sequence of bit fields as an unsigned integer.
  ///
  /// *Factory*: {@link module:Layout.bits|bits}
  ///
  /// This is a container element; within it there are {@link BitField}
  /// instances that provide the extracted properties.  The container
  /// simply defines the aggregate representation and its bit ordering.
  /// The representation is an object containing properties with numeric
  /// or {@link Boolean} values.
  ///
  /// {@link BitField}s are added with the {@link
  /// BitStructure#addField|addField} and {@link
  /// BitStructure#addBoolean|addBoolean} methods.
  /// @param {Layout} word - initialiser for {@link
  /// BitStructure#word|word}.  The parameter must be an instance of
  /// {@link UInt} (or {@link UIntBE}) that is no more than 4 bytes wide.
  ///
  /// @param {bool} [msb] - `true` if the bit numbering starts at the
  /// most significant bit of the containing word; `false` (default) if
  /// it starts at the least significant bit of the containing word.  If
  /// the parameter at this position is a string and `property` is
  /// `undefined` the value of this argument will instead be used as the
  /// value of `property`.
  ///
  /// @param {string} [property] - initialiser for {@link
  /// Layout#property|property}.
  ///
  /// @augments {Layout}
  BitStructure(this.word, this.msb, final int span, [final String? property])
    : super(<BitField>[], span, property);

  /// The layout used for the packed value.  {@link BitField}
  /// instances are packed sequentially depending on {@link
  /// BitStructure#msb|msb}.
  final Layout<int> word;

  /// Whether the bit sequences are packed starting at the most
  /// significant bit growing down (`true`), or the least significant
  /// bit growing up (`false`).
  ///
  /// **NOTE** Regardless of this value, the least significant bit of
  /// any {@link BitField} value is the least significant bit of the
  /// corresponding section of the packed value.
  final bool msb;

  /// The sequence of {@link BitField} layouts that comprise the
  /// packed structure.
  ///
  /// **NOTE** The array remains mutable to allow fields to be {@link
  /// BitStructure#addField|added} after construction.  Users should
  /// not manipulate the content of this property.
  /// 
  /// Defined in [StructureLayout]
  /// final List<BitField> fields = [];

  /// Packed value.
  int _value = 0;

  /// Create an instance of [BitStructure].
  factory BitStructure.constructor(final Layout<int> word, final bool msb, [final String? property]) {
    if (word is! UInt && word is! UIntBE) {
      throw Exception('word must be a UInt or UIntBE layout');
    }
    if (word.span > 4) {
      throw RangeError('word cannot exceed 32 bits');
    }
    return BitStructure(word, msb, word.span, property);
  }

  /// Storage for [_value].
  BitStructure _packedSetValue(final int v) {
    _value = fixBitwiseResult(v);
    return this;
  }
  int _packedGetValue() {
    return _value;
  }

  @override
  Map<String, dynamic> decode(final Buffer b, [int offset = 0]) {
    final dest = makeDestinationObject();
    final value = word.decode(b, offset);
    _packedSetValue(value);
    for (final BitField fd in fields) {
      final String? property = fd.property;
      if (property != null) {
        dest[property] = fd.decode();
      }
    }
    return dest;
  }

  /// Implement {@link Layout#encode|encode} for {@link BitStructure}.
  ///
  /// If `src` is missing a property for a member with a defined {@link
  /// Layout#property|property} the corresponding region of the packed
  /// value is left unmodified.  Unused bits are also left unmodified.
  @override
  int encode(final Map<String, dynamic> src, final Buffer b, [int offset = 0]) {
    final value = word.decode(b, offset);
    _packedSetValue(value);
    for (final BitField fd in fields) {
      final String? property = fd.property;
      if (property != null) {
        final fv = src[property];
        if (fv != null) {
          fd.encode(fv);
        }
      }
    }
    return word.encode(_packedGetValue(), b, offset);
  }

  /// Register a new bitfield with a containing bit structure.  The
  /// resulting bitfield is returned.
  ///
  /// @param {Number} bits - initialiser for {@link BitField#bits|bits}.
  ///
  /// @param {string} property - initialiser for {@link
  /// Layout#property|property}.
  ///
  /// @return {BitField} */
  BitField addField(final int bits, [final String? property]) {
    final bf = BitField.constructor(this, bits, property);
    fields.add(bf);
    return bf;
  }

  /// As with {@link BitStructure#addField|addField} for single-bit
  /// fields with `boolean` value representation.
  ///
  /// @param {string} property - initialiser for {@link
  /// Layout#property|property}.
  ///
  /// @return {Boolean} */
  Boolean addBoolean([final String? property]) {
    // This is my Boolean, not the Javascript one.
    // eslint-disable-next-line no-new-wrappers
    final bf = Boolean.constructor(this, property);
    fields.add(bf);
    return bf;
  }

  /// Get access to the bit field for a given property.
  ///
  /// @param {String} property - the bit field of interest.
  ///
  /// @return {BitField} - the field associated with `property`, or
  /// undefined if there is no such property.
  BitField? fieldFor(final String property) {
    for (final BitField fd in fields) {
      if (fd.property == property) {
        return fd;
      }
    }
    return null;
  }
  
  @override
  BitStructure replicate(final String property) => BitStructure.constructor(word, msb, property);
}


/// Bit Field
/// ------------------------------------------------------------------------------------------------

class BitField extends LayoutProperties with LayoutMixin {

  /// Represent a sequence of bits within a {@link BitStructure}.
  ///
  /// All bit field values are represented as unsigned integers.
  ///
  /// **NOTE** User code should not invoke this constructor directly.
  /// Use the container {@link BitStructure#addField|addField} helper
  /// method.
  ///
  /// **NOTE** BitField instances are not instances of {@link Layout}
  /// since {@link Layout#span|span} measures 8-bit units.
  ///
  /// @param {BitStructure} container - initialiser for {@link
  /// BitField#container|container}.
  ///
  /// @param {Number} bits - initialiser for {@link BitField#bits|bits}.
  ///
  /// @param {string} [property] - initialiser for {@link
  /// Layout#property|property}.
  BitField(this.container, int bits, this.valueMask, this.start, this.wordMask, String? property)
    : super(bits, property);

  /// The {@link BitStructure} instance to which this bit field belongs.
  final BitStructure container;

  /// The span of this value in bits.
  int get bits => span;

  /// A mask of {@link BitField#bits|bits} bits isolating value bits
  /// that fit within the field.
  ///
  /// That is, it masks a value that has not yet been shifted into
  /// position within its containing packed integer.
  final int valueMask;

  /// The offset of the value within the containing packed unsigned
  /// integer.  The least significant bit of the packed value is at
  /// offset zero, regardless of bit ordering used.
  final int start;

  /// A mask of {@link BitField#bits|bits} isolating the field value
  /// within the containing packed unsigned integer.
  final int wordMask;

  /// The property name used when this bitfield is represented in an
  /// Object.
  ///
  /// Intended to be functionally equivalent to {@link
  /// Layout#property}.
  ///
  /// If left undefined the corresponding span of bits will be
  /// treated as padding: it will not be mutated by {@link
  /// Layout#encode|encode} nor represented as a property in the
  /// decoded Object.
  ///
  /// Defined in [Layout]
  /// final String? property;

  /// Create an instance of [BitField].
  factory BitField.constructor(
    final BitStructure container, 
    final int bits, [
    final String? property,
  ]) {
    if (bits <= 0) {
      throw RangeError('bits must be positive integer');
    }
    final int totalBits = 8 * container.span;
    final int usedBits = container.fields.fold(0, (sum, fd) => sum + fd.bits);
    if ((bits + usedBits) > totalBits) {
      throw RangeError('bits too long for span remainder '
                       '(${totalBits - usedBits}) of ' 
                       '$totalBits remain');
    }

    int valueMask = (1 << bits) - 1;
    if (bits == 32) { // shifted value out of range
      valueMask = 0xFFFFFFFF;
    }

    int start = usedBits;
    if (container.msb) {
      start = totalBits - usedBits - bits;
    }

    int wordMask = fixBitwiseResult(valueMask << start);

    return BitField(container, bits, valueMask, start, wordMask, property);
  }

  /// Store a value into the corresponding subsequence of the containing
  /// bit field. */
  dynamic decode() {
    final word = container._packedGetValue();
    final wordValue = fixBitwiseResult(word & wordMask);
    return wordValue >>> start;
  }

  /// Store a value into the corresponding subsequence of the containing
  /// bit field.
  ///
  /// **NOTE** This is not a specialization of {@link
  /// Layout#encode|Layout.encode} and there is no return value. */
  void encode(dynamic value) {
    value as int;
    check(value == fixBitwiseResult(value & valueMask), 
          '${debugProperty(property)} encode() value must not exceed $valueMask.');
    final word = container._packedGetValue();
    final wordValue = fixBitwiseResult(value << start);
    container._packedSetValue(fixBitwiseResult(word & ~wordMask) | wordValue);
  }
}


/// Boolean
/// ------------------------------------------------------------------------------------------------

class Boolean extends BitField {

  /// Represent a single bit within a {@link BitStructure} as a
  /// JavaScript boolean.
  ///
  /// **NOTE** User code should not invoke this constructor directly.
  /// Use the container {@link BitStructure#addBoolean|addBoolean} helper
  /// method.
  ///
  /// @param {BitStructure} container - initialiser for {@link
  /// BitField#container|container}.
  ///
  /// @param {string} [property] - initialiser for {@link
  /// Layout#property|property}.
  ///
  /// @augments {BitField}
  Boolean(
    final BitStructure container, 
    final int valueMask,
    final int start,
    final int wordMask,
    final String? property,
  ) : super(container, 1, valueMask, start, wordMask, property);

  /// Create an instance of [Boolean].
  factory Boolean.constructor(final BitStructure container, [final String? property]) {
    final BitField bitField = BitField.constructor(container, 1, property);
    return Boolean(
      bitField.container, bitField.valueMask, 
      bitField.start, bitField.wordMask, bitField.property,
    );
  }

  @override
  bool decode() {
    return super.decode() != 0;
  }

  @override
  void encode(final dynamic value) {
    return super.encode((value as bool) ? 1 : 0);
  }
}


/// Blob
/// ------------------------------------------------------------------------------------------------

class Blob<T> extends Layout<Iterable<int>> {

  /// Contain a fixed-length block of arbitrary data, represented as a
  /// Buffer.
  ///
  /// *Factory*: {@link module:Layout.blob|blob}
  ///
  /// @param {(Number|ExternalLayout)} length - initialises {@link
  /// Blob#length|length}.
  ///
  /// @param {String} [property] - initialiser for {@link
  /// Layout#property|property}.
  ///
  /// @augments {Layout}
  Blob(this.length, final int span, final String property)
    : super(span, property);

  /// The number of bytes in the blob.
  ///
  /// This may be a non-negative integer, or an instance of {@link
  /// ExternalLayout} that satisfies {@link
  /// ExternalLayout#isCount|isCount()}. */
  final T length;

  factory Blob.constructor(final T length, final String property) {
    if (!((length is ExternalLayout && length.isCount()) || (length is int && length >= 0))) {
      throw Exception('length must be a positive integer or an unsigned integer ExternalLayout');
    }
    return Blob(length, length is int ? length : -1, property);
  }

  @override
  int getSpan(final Buffer b, [int offset = 0]) {
    int span = this.span;
    if (span < 0) {
      span = (length as ExternalLayout).decode(b, offset);
    }
    return span;
  }

  @override
  Buffer decode(final Buffer b, [int offset = 0]) {
    int span = this.span;
    if (span < 0) {
      span = (length as ExternalLayout).decode(b, offset);
    }
    return b.slice(offset, span);
  }

  /// Implement {@link Layout#encode|encode} for {@link Blob}.
  ///
  /// **NOTE** If {@link Layout#count|count} is an instance of {@link
  /// ExternalLayout} then the length of `src` will be encoded as the
  /// count after `src` is encoded.
  @override
  int encode(final Iterable<int> src, final Buffer b, [int offset = 0]) {
    final int span = length is int ? length as int : src.length;
    check(span == src.length, '${debugProperty(property)} encode() requires (length $span)');
    check((offset + span) <= b.length, 
            'encoding overruns Buffer (offset: $offset) - (span: $span) - (buffer: ${b.length})');
    b.setString(Buffer.fromList(src).getString(BufferEncoding.hex), BufferEncoding.hex, offset, span);
    if (length is ExternalLayout) {
      (length as ExternalLayout).encode(span, b, offset);
    }
    return span;
  }
  
  @override
  Blob replicate(final String property) => Blob.constructor(length, property);
}


/// CString
/// ------------------------------------------------------------------------------------------------

class CString extends Layout<String> {

  /// Contain a `NUL`-terminated UTF8 string.
  ///
  /// *Factory*: {@link module:Layout.cstr|cstr}
  ///
  /// **NOTE** Any UTF8 string that incorporates a zero-valued byte will
  /// not be correctly decoded by this layout.
  ///
  /// @param {String} [property] - initialiser for {@link
  /// Layout#property|property}.
  ///
  /// @augments {Layout}
  const CString([final String? property])
    : super(-1, property);

  @override
  int getSpan(final Buffer b, [int offset = 0]) {
    int idx = offset;
    while (idx < b.length && b[idx] != 0) {
      idx += 1;
    }
    return 1 + idx - offset;
  }

  @override
  String decode(final Buffer b, [int offset = 0]) {
    int span = getSpan(b, offset);
    return b.getString(BufferEncoding.utf8, offset, span - 1);
  }

  @override
  int encode(final String src, final Buffer b, [int offset = 0]) {
    final Buffer srcb = Buffer.fromString(src);
    final int span = srcb.length;
    check((offset + span) <= b.length, 'encoding overruns Buffer');
    srcb.copy(b, offset);
    b[offset + span] = 0;
    return span + 1;
  }
  
  @override
  CString replicate(final String property) => CString(property);
}


/// UTF8
/// ------------------------------------------------------------------------------------------------

/// Contain a UTF8 string with implicit length.
///
/// *Factory*: {@link module:Layout.utf8|utf8}
///
/// **NOTE** Because the length is implicit in the size of the buffer
/// this layout should be used only in isolation, or in a situation
/// where the length can be expressed by operating on a slice of the
/// containing buffer.
///
/// @param {Number} [maxSpan] - the maximum length allowed for encoded
/// string content.  If not provided there is no bound on the allowed
/// content.
///
/// @param {String} [property] - initialiser for {@link
/// Layout#property|property}.
///
/// @augments {Layout}
class UTF8 extends Layout<String> {

  const UTF8([final int? maxSpan, final String? property])
    : maxSpan = maxSpan ?? -1,
      super(-1, property);

  /// The maximum span of the layout in bytes.
  ///
  /// Positive values are generally expected.  Zero is abnormal.
  /// Attempts to encode or decode a value that exceeds this length
  /// will throw a `RangeError`.
  ///
  /// A negative value indicates that there is no bound on the length
  /// of the content.
  final int maxSpan;

  @override
  int getSpan(final Buffer b, [int offset = 0]) {
    return b.length - offset;
  }

  @override
  String decode(final Buffer b, [int offset = 0]) {
    int span = getSpan(b, offset);
    check(maxSpan < 0 || span <= maxSpan, 'text span exceeds maxSpan.');
    return b.getString(BufferEncoding.utf8, offset, span);
  }

  @override
  int encode(final String src, final Buffer b, [int offset = 0]) {
    /// Must force this to a string, let it be a number and the
    /// "utf8-encoding" below actually allocate a buffer of length
    /// src
    final Buffer srcb = Buffer.fromString(src);
    final span = srcb.length;
    check(maxSpan < 0 || span <= maxSpan, 'text span exceeds maxSpan.');
    check((offset + span) <= b.length, 'encoding overruns Buffer.');
    srcb.copy(b, offset);
    return span;
  }
  
  @override
  UTF8 replicate(final String property) => UTF8(maxSpan, property);
}


/// Constant
/// ------------------------------------------------------------------------------------------------

/// Contain a constant value.
///
/// This layout may be used in cases where a JavaScript value can be
/// inferred without an expression in the binary encoding.  An example
/// would be a {@link VariantLayout|variant layout} where the content
/// is implied by the union {@link Union#discriminator|discriminator}.
///
/// @param {Object|Number|String} value - initialiser for {@link
/// Constant#value|value}.  If the value is an object (or array) and
/// the application intends the object to remain unchanged regardless
/// of what is done to values decoded by this layout, the value should
/// be frozen prior passing it to this constructor.
///
/// @param {String} [property] - initialiser for {@link
/// Layout#property|property}.
///
/// @augments {Layout}
class Constant<T> extends Layout<T> {

  const Constant(this.value, final String? property)
    : super(0, property);

  /// The value produced by this constant when the layout is {@link
  /// Constant#decode|decoded}.
  ///
  /// Any JavaScript value including `null` and `undefined` is
  /// permitted.
  ///
  /// **WARNING** If `value` passed in the constructor was not
  /// frozen, it is possible for users of decoded values to change
  /// the content of the value.
  final T value;

  @override
  T decode(final Buffer b, [int offset = 0]) {
    return value;
  }

  @override
  int encode(final T src, final Buffer b, [int offset = 0]) {
    return 0; /// Constants take no space
  }
  
  @override
  Constant replicate(final String property) => Constant(value, property);
}


/// Factory Methods
/// ------------------------------------------------------------------------------------------------

/// Factory for {@link GreedyCount}.
GreedyCount greedy([final int? elementSpan, final String? property]) {
  return GreedyCount(elementSpan, property);
}

/// Factory for {@link OffsetLayout}.
OffsetLayout<T> offset<T>(final Layout<T> layout, [final int? offset, final String? property]) {
  return OffsetLayout<T>(layout, offset, property);
}

/// Factory for {@link UInt|unsigned int layouts} spanning one byte.
UInt u8([final String? property]) => UInt(1, property);

/// Factory for {@link UInt|little-endian unsigned int layouts} spanning two bytes.
UInt u16([final String? property]) => UInt(2, property);

/// Factory for {@link UInt|little-endian unsigned int layouts} spanning three bytes.
UInt u24([final String? property]) => UInt(3, property);

/// Factory for {@link UInt|little-endian unsigned int layouts} spanning four bytes.
UInt u32([final String? property]) => UInt(4, property);

/// Factory for {@link UInt|little-endian unsigned int layouts} spanning five bytes.
UInt u40([final String? property]) => UInt(5, property);

/// Factory for {@link UInt|little-endian unsigned int layouts} spanning six bytes.
UInt u48([final String? property]) => UInt(6, property);

/// Factory for {@link NearUInt64|little-endian unsigned int layouts} interpreted as Numbers.
NearUInt64 nu64([final String? property]) => NearUInt64(property);

/// Factory for {@link UInt|big-endian unsigned int layouts} spanning two bytes.
UIntBE u16be([final String? property]) => UIntBE(2, property);

/// Factory for {@link UInt|big-endian unsigned int layouts} spanning three bytes.
UIntBE u24be([final String? property]) => UIntBE(3, property);

/// Factory for {@link UInt|big-endian unsigned int layouts} spanning four bytes.
UIntBE u32be([final String? property]) => UIntBE(4, property);

/// Factory for {@link UInt|big-endian unsigned int layouts} spanning five bytes.
UIntBE u40be([final String? property]) => UIntBE(5, property);

/// Factory for {@link UInt|big-endian unsigned int layouts} spanning six bytes.
UIntBE u48be([final String? property]) => UIntBE(6, property);

/// Factory for {@link NearUInt64BE|big-endian unsigned int layouts} interpreted as Numbers.
NearUInt64BE nu64be([final String? property]) => NearUInt64BE(property);

/// Factory for {@link Int|signed int layouts} spanning one byte.
Int s8([final String? property]) => Int(1, property);

/// Factory for {@link Int|little-endian signed int layouts} spanning two bytes.
Int s16([final String? property]) => Int(2, property);

/// Factory for {@link Int|little-endian signed int layouts} spanning three bytes.
Int s24([final String? property]) => Int(3, property);

/// Factory for {@link Int|little-endian signed int layouts} spanning four bytes.
Int s32([final String? property]) => Int(4, property);

/// Factory for {@link Int|little-endian signed int layouts} spanning five bytes.
Int s40([final String? property]) => Int(5, property);

/// Factory for {@link Int|little-endian signed int layouts} spanning six bytes.
Int s48([final String? property]) => Int(6, property);

/// Factory for {@link NearInt64|little-endian signed int layouts} interpreted as Numbers.
NearInt64 ns64([final String? property]) => NearInt64(property);

/// Factory for {@link Int|big-endian signed int layouts} spanning two bytes.
IntBE s16be([final String? property]) => IntBE(2, property);

/// Factory for {@link Int|big-endian signed int layouts} spanning three bytes.
IntBE s24be([final String? property]) => IntBE(3, property);

/// Factory for {@link Int|big-endian signed int layouts} spanning four bytes.
IntBE s32be([final String? property]) => IntBE(4, property);

/// Factory for {@link Int|big-endian signed int layouts} spanning five bytes.
IntBE s40be([final String? property]) => IntBE(5, property);

/// Factory for {@link Int|big-endian signed int layouts} spanning six bytes.
IntBE s48be([final String? property]) => IntBE(6, property);

/// Factory for {@link NearInt64BE|big-endian signed int layouts} interpreted as Numbers.
NearInt64BE ns64be([final String? property]) => NearInt64BE(property);

/// Factory for {@link Float|little-endian 32-bit floating point} values.
Float f32([final String? property]) => Float(property);

/// Factory for {@link FloatBE|big-endian 32-bit floating point} values.
FloatBE f32be([final String? property]) => FloatBE(property);

/// Factory for {@link Double|little-endian 64-bit floating point} values.
Double f64([final String? property]) => Double(property);

/// Factory for {@link DoubleBE|big-endian 64-bit floating point} values.
DoubleBE f64be([final String? property]) => DoubleBE(property);

/// Factory for {@link Structure} values.
Structure struct(
  final List<Layout> fields, [
  final String? property, 
  final bool? decodePrefixes,
]) {
  return Structure(fields, property, decodePrefixes);
}

/// Factory for {@link Structure} values.
RustString rustString(
  final List<Layout> fields, [
  final String? property, 
  final bool? decodePrefixes,
]) { 
  return RustString(fields, property, decodePrefixes);
}

/// Factory for {@link BitStructure} values.
BitStructure bits(final Layout<int> word, final bool msb, [final String? property]) { 
  return BitStructure.constructor(word, msb, property);
}

/// Factory for {@link Sequence} values.
Sequence<T> seq<T>(final Layout<T> elementLayout, final dynamic count, [final String? property]) { 
  return Sequence<T>(elementLayout, count, property);
}

/// Factory for {@link Union} values.
Union union(final dynamic discr, [final Layout? defaultLayout, final String? property]) {
  return Union.constructor(discr, defaultLayout, property);
}

/// Factory for {@link UnionLayoutDiscriminator} values.
UnionLayoutDiscriminator<T> unionLayoutDiscriminator<T>(
  final ExternalLayout<T> layout, [
  final String? property,
]) {
  return UnionLayoutDiscriminator<T>(layout, property);
}

/// Factory for {@link Blob} values.
Blob<T> blob<T>(final T length, final String property) => Blob<T>.constructor(length, property);

/// Factory for {@link CString} values.
CString cstr([final String? property]) => CString(property);

/// Factory for {@link UTF8} values.
UTF8 utf8([final int? maxSpan, final String? property]) => UTF8(maxSpan, property);

/// Factory for {@link Constant} values.
Constant<T> constant<T>(final T value, [final String? property]) => Constant(value, property);