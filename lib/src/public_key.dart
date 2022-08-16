/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:typed_data' show ByteBuffer, Uint8List;
import 'package:crypto/crypto.dart' show sha256;
import '../exceptions/ed25519_exception.dart';
import '../exceptions/public_key_exception.dart';
import 'extensions/big_int.dart';
import 'models/program_address.dart';
import 'models/serialisable.dart';
import 'nacl.dart' as nacl show publicKeyLength, maxSeedLength;
import 'nacl_low_level.dart' as nacl_low_level;
import 'utils/convert.dart' show base58;
import 'utils/library.dart' show require;


/// Public Key
/// ------------------------------------------------------------------------------------------------

class PublicKey extends Serialisable {

  /// Creates a [PublicKey] from an `ed25519` public key [value].
  const PublicKey(
    final BigInt value,
  ):  _value = value;

  /// The public key's `ed25519` value.
  final BigInt _value;
  
  /// Creates a default [PublicKey] (0 => '11111111111111111111111111111111').
  factory PublicKey.zero() {
    return PublicKey(BigInt.zero);
  }

  /// Creates a [PublicKey] from a `base-58` encoded [publicKey].
  factory PublicKey.fromString(final String publicKey) {
    return PublicKey.fromUint8List(base58.decode(publicKey));
  }
  
  /// Creates a [PublicKey] from a `base-58` encoded [publicKey].
  /// 
  /// Returns `null` if [publicKey] is omitted.
  static PublicKey? tryFromString(final String? publicKey) {
    return publicKey != null ? PublicKey.fromString(publicKey) : null;
  }

  /// Creates a [PublicKey] from a byte array [publicKey].
  factory PublicKey.fromUint8List(final Iterable<int> publicKey) {
    require(publicKey.length <= nacl.publicKeyLength, 'Invalid public key length.');
    return PublicKey(BigIntExtension.fromUint8List(publicKey));
  }

  @override
  int get hashCode => _value.hashCode;

  @override
  bool operator ==(Object other) {
    return other is PublicKey && _value == other._value;
  }

  /// Compares this [PublicKey] to [other].
  /// 
  /// Returns a negative value if `this` is ordered before `other`, a positive value if `this` is 
  /// ordered after `other`, or zero if `this` and `other` are equivalent. Ordering is based on the
  /// [BigInt] value of the public keys.
  int compareTo(final PublicKey other) {
    return _value.compareTo(other._value);
  }

  /// Returns true if this [PublicKey] is equal to the provided [publicKey].
  bool equals(final PublicKey publicKey) {
    return _value == publicKey._value;
  }

  /// Returns this [PublicKey] as a `base-58` encoded string.
  String toBase58() {
    return base58.encode(toBytes());
  }

  /// Returns this [PublicKey] as a byte array.
  Uint8List toBytes() {
    return _value.toUint8List(nacl.publicKeyLength);
  }

  /// Returns this [PublicKey] as a byte buffer.
  ByteBuffer toBuffer() {
    return toBytes().buffer;
  }

  /// Returns this [PublicKey] as a `base-58` encoded string.
  @override
  String toString() {
    return toBase58();
  }

  /// Returns this [PublicKey] as a `base-58` encoded string.
  @override
  Map<String, dynamic> toJson() {
    throw toBase58();
  }

  /// Derives a [PublicKey] from another [publicKey], [seed], and [programId].
  /// 
  /// The program Id will also serve as the owner of the public key, giving it permission to write 
  /// data to the account.
  static PublicKey createWithSeed(
    final PublicKey publicKey,
    final String seed,
    final PublicKey programId,
  ) {
    final Uint8List seedBytes = Uint8List.fromList(seed.codeUnits);
    final List<int> buffer = publicKey.toBytes() + seedBytes + programId.toBytes();
    return PublicKey.fromUint8List(sha256.convert(buffer).bytes);
  }

  /// Derives a program address from the [seeds] and [programId].
  /// 
  /// Throws an [AssertionError] if [seeds] contains an invalid seed.
  /// 
  /// Throws an [ED25519Exception] if the generated [PublicKey] falls on the `ed25519` curve.
  static PublicKey createProgramAddress(
    final List<List<int>> seeds,
    final PublicKey programId,
  ) {
    final List<int> buffer = [];
    
    for (final List<int> seed in seeds) {
      require(seed.length <= nacl.maxSeedLength, 'Invalid seed length.');
      buffer.addAll(seed);
    }

    buffer..addAll(programId.toBytes())
          ..addAll('ProgramDerivedAddress'.codeUnits);

    final PublicKey publicKey = PublicKey.fromUint8List(sha256.convert(buffer).bytes);

    if (isOnCurve(publicKey)) {
      throw ED25519Exception(
        'Invalid seeds $seeds\n'
        'The public key address must fall off the `ed25519` curve.'
      );
    }

    return publicKey;
  }

  /// Finds a valid program address for the given [seeds] and [programId].
  ///
  /// `Valid program addresses must fall off the ed25519 curve.` This function iterates a nonce 
  /// until it finds one that can be combined with the seeds to produce a valid program address.
  /// 
  /// Throws an [AssertionError] if [seeds] contains an invalid seed.
  /// 
  /// Throws a [PublicKeyException] if a valid program address could not be found.
  static ProgramAddress findProgramAddress(
    final List<List<int>> seeds,
    final PublicKey programId,
  ) {
    for (int nonce = 255; nonce > 0; --nonce) {
      try {
        final List<List<int>> seedsWithNonce = seeds + [[nonce]];
        final PublicKey address = createProgramAddress(seedsWithNonce, programId);
        return ProgramAddress(address, nonce);
      } on AssertionError {
        rethrow;
      } catch (_) {
      }
    }

    throw const PublicKeyException('Unable to find a viable program address nonce.');
  }

  /// Returns true if [publicKey] falls on the `ed25519` curve.
  static bool isOnCurve(PublicKey publicKey) {
    return nacl_low_level.isOnCurve(publicKey.toBytes()) == 1;
  }
}