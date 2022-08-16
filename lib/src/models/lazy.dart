/// Lazy
/// ------------------------------------------------------------------------------------------------

class Lazy<T> {
  
  Lazy(
    this.factory, { 
    T? value, 
  }): _value = value;

  T? _value;

  T Function() factory;

  T get value => _value ??= factory();

  bool get isInitialised => _value != null;
}