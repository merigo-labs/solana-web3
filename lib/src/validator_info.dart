/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:convert';
import 'package:solana_web3/src/buffer.dart';
import 'package:solana_web3/src/buffer_layout.dart' as layout show rustString;
import 'package:solana_web3/src/nacl.dart' as nacl show publicKeyLength;
import 'package:solana_web3/src/public_key.dart';
import 'package:solana_web3/src/utils/shortvec.dart' as shortvec;


/// Validator Info Public Key
/// ------------------------------------------------------------------------------------------------

final PublicKey validatorInfoPublicKey = PublicKey.fromString(
  'Va1idator1nfo111111111111111111111111111111',
);


/// Configuration Public Key
/// ------------------------------------------------------------------------------------------------

class ConfigKey {

  const ConfigKey(
    this.publicKey, {
    required this.isSigner,
  });

  final PublicKey publicKey;
  final bool isSigner;
}


/// Info
/// ------------------------------------------------------------------------------------------------

class Info {

  /// Info used to identity validators.
  const Info({
    required this.name,
    this.website,
    this.details,
    this.keybaseUsername,
  });

  /// Validator name.
  final String name;

  /// Validator website.
  final String? website;
  
  /// Extra information the validator chose to share.
  final String? details;

  /// Uused to identify validators on keybase.io.
  final String? keybaseUsername;

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// Info.fromJson({ '<parameter>': <value> });
  /// ```
  factory Info.fromJson(final Map<String, dynamic> json) => Info(
    name: json['name'],
    website: json['website'],
    details: json['details'],
    keybaseUsername: json['keybaseUsername'],
  );
}


/// Validator Info
/// ------------------------------------------------------------------------------------------------

class ValidatorInfo {

  /// Validator Info
  const ValidatorInfo({
    required this.key,
    required this.info,
  });

  /// Validator public key.
  final PublicKey key;

  /// Validator information.
  final Info info;

  /// Deserialises [ValidatorInfo] from the config account data. Exactly two config keys are 
  /// required in the data.
  /// 
   /// Returns null if info was not found.
  static ValidatorInfo? tryFromConfigData(Buffer data) {
    
    const keyLength = 2;

    if (shortvec.decodeLength(data) == keyLength) {

      final List<ConfigKey> configKeys = [];
      for (int i = 0; i < keyLength; ++i) {
        final publicKey = PublicKey.fromUint8List(data.slice(0, nacl.publicKeyLength));
        data = data.slice(nacl.publicKeyLength);
        final bool isSigner = data.slice(0, 1)[0] == 1;
        data = data.slice(1);
        configKeys.add(ConfigKey(publicKey, isSigner: isSigner));
      }

      if (configKeys[0].publicKey.equals(validatorInfoPublicKey)) {
        if (configKeys[1].isSigner) {
          final String rawInfo = layout.rustString([]).decode(Buffer.fromList(data));
          final Info info = Info.fromJson(json.decode(rawInfo));
          return ValidatorInfo(key: configKeys[1].publicKey, info: info);
        }
      }
    }

    return null;
  }
}