/// Stake Instruction
/// ------------------------------------------------------------------------------------------------

enum StakeInstruction {
  initialize,
  authorize,
  delegateStake,
  split,
  withdraw,
  deactivate,
  setLockup,
  merge,
  authorizeWithSeed,
  initializeChecked,
  authorizeChecked,
  authorizeCheckedWithSeed,
  setLockupChecked,
  getMinimumDelegation,
  deactivateDelinquent,
  redelegate,
}