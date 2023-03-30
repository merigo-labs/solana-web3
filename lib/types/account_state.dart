/// Account State
/// ------------------------------------------------------------------------------------------------

enum AccountState {
  
  /// Account is not yet initialized.
  uninitialized,
  
  /// Account is initialized; the account owner and/or delegate may perform permitted operations on 
  /// this account.
  initialized,
  
  /// Account has been frozen by the mint freeze authority. Neither the account owner nor the 
  /// delegate are able to perform operations on this account.
  frozen,
}