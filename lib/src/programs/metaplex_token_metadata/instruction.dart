/// Metaplex Token Metadata Instruction
/// ------------------------------------------------------------------------------------------------

enum MetaplexTokenMetadataInstruction {
  updateMetadataAccountV2(15),
  createMetadataAccountV3(33),
  ;
  const MetaplexTokenMetadataInstruction(this.discriminator);
  final int discriminator;
}