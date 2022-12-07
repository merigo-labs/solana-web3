/// Imports
/// ------------------------------------------------------------------------------------------------

import 'buffer_layout.dart' as buffer_layout;
import 'package:solana_common/utils/types.dart' show u8;


/// Layouts
/// ------------------------------------------------------------------------------------------------

/// Returns the layout for a public key.
buffer_layout.Blob<u8> publicKey([final String property = 'publicKey']) { 
  return buffer_layout.blob<u8>(32, property);
}

/// Returns the layout a signature
buffer_layout.Blob<u8> signature([final String property = 'signature']) { 
  return buffer_layout.blob(64, property);
}

/// Returns the layout for a 64-bit unsigned integer.
buffer_layout.Blob<u8> uint64([final String property = 'uint64']) { 
  return buffer_layout.blob<u8>(8, property);
}

/// Returns the layout for a Rust String type.
buffer_layout.RustString rustString([final String property = 'string']) { 
  return buffer_layout.rustString(
    [
      buffer_layout.u32('length'),
      buffer_layout.u32('lengthPadding'),
      buffer_layout.blob(buffer_layout.offset(buffer_layout.u32(), -8), 'chars'),
    ],
    property,
  );
}

/// Returns the layout for an Authorised object.
buffer_layout.Structure authorized([final String property = 'authorized']) {
  return buffer_layout.struct(
    [
      publicKey('staker'), 
      publicKey('withdrawer')
    ], 
    property,
  );
}

/// Returns the layout for a Lockup object.
buffer_layout.Structure lockup([final String property = 'lockup']) {
  return buffer_layout.struct(
    [
      buffer_layout.ns64('unixTimestamp'),
      buffer_layout.ns64('epoch'),
      publicKey('custodian'),
    ],
    property,
  );
}

/// Returns the layout for a VoteInit object.
buffer_layout.Structure voteInit([final String property = 'voteInit']) {
  return buffer_layout.struct(
    [
      publicKey('nodePubkey'),
      publicKey('authorizedVoter'),
      publicKey('authorizedWithdrawer'),
      buffer_layout.u8('commission'),
    ],
    property,
  );
}

/// Calculates the size of a structure [layout]. The size of a [buffer_layout.StructureLayout] is 
/// determined by the sum of its [buffer_layout.StructureLayout.fields] property. 
/// [buffer_layout.RustString] will use [fields] to calculate the size of a property when its span 
/// is a negative integer.
int getAlloc<T extends buffer_layout.Layout>(
  final buffer_layout.StructureLayout layout, 
  final Map<String, dynamic> fields,
) {
  int alloc = 0;
  for (final buffer_layout.LayoutProperties item in layout.fields) {
    if (item.span >= 0) {
      alloc += item.span;
    } else if (item is buffer_layout.RustString && item.property != null) {
      final dynamic value = fields[item.property];
      if (value != null && value is String) {
        alloc += item.alloc(value);
      } else {
        print(
          '[WARNING] Found non String `fields` property '
          '(key: ${item.property}) (value: $value)'
        );
      }
    }
  }
  return alloc;
}