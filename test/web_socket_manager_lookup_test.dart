/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter_test/flutter_test.dart';
import 'package:solana_web3/web_socket_manager_lookup.dart';


///  Web Socket Manager Map Tests
/// ------------------------------------------------------------------------------------------------

void main() {

  _testMultiKey<T>(final List<T> keys) {
    
    final String value = 'Testing MultiKey<$T>';
    final map = WebSocketManagerLookup<MultiKey, String>();
    assert(map.length == 0);

    map[MultiKey(keys)] = value;
    assert(map.length == 1);

    for (final T key in keys) {
      assert(map[key] == value);
    }

    for (int i = 0; i < keys.length; ++i) {
      final v = map.remove(keys[i]);
      if (i == 0) {
        assert(v == value);
      } else {
        assert(v == null);
      }
    }
    
    assert(map.length == 0);
  }
  
  test('multi key (int)', () {
    _testMultiKey<int>([1, 2, 3]);
  });
  
  test('multi key (Object)', () {
    _testMultiKey<Object>([1, '2', 'three']);
  });

  test('set multi key', () {
    final lookup = WebSocketManagerLookup();
    
    const v1 = 1000;
    lookup[MultiKey(['a', 'b', 'c'])] = v1;
    assert(lookup['a'] == v1 && lookup['b'] == v1 && lookup['c'] == v1);

    const v2 = 2000;
    lookup[MultiKey(['a', 'b', 'c'])] = v2;
    assert(lookup['a'] == v2 && lookup['b'] == v2 && lookup['c'] == v2);

    try {
      const v3 = 3000;
      lookup[MultiKey(['x', 'b', 'z'])] = v3; // should throw.
      assert(false, 'The key "b" already exists at index 1 for a different key.');
    } catch (e) {
      assert(lookup['a'] == v2 && lookup['b'] == v2 && lookup['c'] == v2);
    }
    
    const v4 = 4000;
    lookup[MultiKey(['x', 'y', 'z'])] = v4;
    assert(lookup['x'] == v4 && lookup['y'] == v4 && lookup['z'] == v4);

    print(lookup);
  });

  test('remove multi key (index)', () {
    final lookup = WebSocketManagerLookup();  //   0    1    2
    lookup[MultiKey(['a', 'b', 'c'])] = 1000; // ['a', 'b', 'c'] => 1000
    lookup[MultiKey(['x', 'y', 'z'])] = 2000; // ['x', 'y', 'z'] => 2000
    
    print(lookup.removeAt('c', index: 0));      // null
    print(lookup.removeAt('c', index: 1));      // null
    print(lookup.removeAt('c', index: 2));      // 1000
  });
}
