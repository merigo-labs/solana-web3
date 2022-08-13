/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/src/blockhash.dart';
import 'package:solana_web3/src/buffer.dart';
import 'package:solana_web3/src/buffer_layout.dart' as buffer_layout;
import 'package:solana_web3/src/fee_calculator.dart';
import 'package:solana_web3/src/layout.dart' as layout;
import 'package:solana_web3/src/public_key.dart';


/// Nonce Account Layout
/// See https://github.com/solana-labs/solana/blob/0ea2843ec9cdc517572b8e62c959f41b55cf4453/sdk/src/nonce_state.rs#L29-L32
/// ------------------------------------------------------------------------------------------------

final buffer_layout.Structure nonceAccountLayout = buffer_layout.struct([
  buffer_layout.u32('version'),
  buffer_layout.u32('state'),
  layout.publicKey('authorizedPubkey'),
  layout.publicKey('nonce'),
  buffer_layout.struct(
    [feeCalculatorLayout],
    'feeCalculator',
  ),
]);

final int nonceAccountLength = nonceAccountLayout.span;


/// Nonce Account
/// ------------------------------------------------------------------------------------------------

class NonceAccount {

  const NonceAccount({
    required this.authorisedPublicKey,
    required this.nonce,
    required this.feeCalculator,
  });
  
  final PublicKey authorisedPublicKey;

  final Blockhash nonce;

  final FeeCalculator feeCalculator;

  /// Creates a [NonceAccount] from the account [data].
  factory NonceAccount.fromAccountData(Buffer data) {
    final Map<String, dynamic> nonceAccount = nonceAccountLayout.decode(data, 0);
    return NonceAccount(
      authorisedPublicKey: PublicKey.fromString(nonceAccount['authorisedPublicKey']),
      nonce: nonceAccount['nonce'],
      feeCalculator: nonceAccount['feeCalculator'],
    );
  }
}