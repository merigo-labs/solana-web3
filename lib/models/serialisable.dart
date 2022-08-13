/// Serialisable
/// ------------------------------------------------------------------------------------------------

abstract class Serialisable extends Object {

  /// Creates a class that can be serialised into a JSON object.
  const Serialisable();

  /// Serialises `this` class into a JSON object.
  /// 
  /// ```
  /// class Item extends Serialisable {
  ///   const(this.name, this.count);
  ///   final String name;
  ///   final int? count;
  /// }
  /// 
  /// final Item x = Item('apple', 10);
  /// print(x.toJson()); // { 'name': 'apple', 'count': 10 }
  /// ```
  Map<String, dynamic> toJson();

  /// Returns the result of [toJson], removing all `null` valued entries.
  /// 
  /// ```
  /// class Item extends Serialisable {
  ///   const(this.name, this.count);
  ///   final String name;
  ///   final int? count;
  /// }
  /// 
  /// final Item x = Item('apple', null);
  /// print(x.toJson());      // { 'name': 'apple', 'count': null }
  /// print(x.toJsonClean()); // { 'name': 'apple' }
  /// ```
  Map<String, dynamic> toJsonClean() {
    return toJson()..removeWhere((_, value) => value == null);
  }
}