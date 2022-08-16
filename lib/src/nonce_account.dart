/// Imports
/// ------------------------------------------------------------------------------------------------

import 'blockhash.dart';
import 'buffer.dart';
import 'buffer_layout.dart' as buffer_layout;
import 'fee_calculator.dart';
import 'layout.dart' as layout;
import 'public_key.dart';


/// Nonce Account Layout
/// ------------------------------------------------------------------------------------------------

/// See https://github.com/solana-labs/solana/blob/0ea2843ec9cdc517572b8e62c959f41b55cf4453/sdk/src/nonce_state.rs#L29-L32
final nonceAccountLayout = buffer_layout.struct([
  buffer_layout.u32('version'),
  buffer_layout.u32('state'),
  layout.publicKey('authorizedPubkey'),
  layout.publicKey('nonce'),
  buffer_layout.struct([feeCalculatorLayout], 'feeCalculator'),
]);

/// Nonce account layout byte length.
final int nonceAccountLength = nonceAccountLayout.span;


/// Nonce Account
/// ------------------------------------------------------------------------------------------------

class NonceAccount {

  /// https://forums.solana.com/t/what-is-nonce-account-used-for/4879
  /// 
  /// Durable transaction nonces are a mechanism for getting around the typical short lifetime of a 
  /// transaction's recent_blockhash.
  /// 
  /// Nonce accounts are used in cases when you need multiple people to sign a transaction, but they 
  /// can’t all be available to sign it on the same computer within a short enough time period.
  /// 
  /// Each transaction submitted on Solana must specify a recent blockhash that was generated within 
  /// 2 minutes of the latest blockhash. If it takes longer than 2 minutes to get everybody’s 
  /// signatures, then you have to use nonce accounts.
  const NonceAccount({
    required this.authorisedPubkey,
    required this.nonce,
    required this.feeCalculator,
  });

  /// The authority of the nonce account.
  final PublicKey authorisedPubkey;
  
  /// The block hash.
  final Blockhash nonce;

  /// Transaction fee calculator.
  final FeeCalculator feeCalculator;

  /// Deserialises a NonceAccount from the account data [buffer].
  factory NonceAccount.fromAccountData(final Buffer buffer) {
    final Map<String, dynamic> nonceAccount = nonceAccountLayout.decode(buffer);
    return NonceAccount(
      authorisedPubkey: PublicKey.fromString(nonceAccount['authorizedPubkey']),
      nonce: PublicKey.fromString(nonceAccount['nonce']).toString(),
      feeCalculator: FeeCalculator.fromJson(nonceAccount['feeCalculator']),
    );
  }
}