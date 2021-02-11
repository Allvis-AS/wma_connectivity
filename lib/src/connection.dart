/// Represents a logical connection between this device and the target resource.
/// Whenever the target resource can be reached [connected] is [true] and
/// vice versa.
abstract class Connection {
  Connection(this.connected);

  /// Whether the target resource can be reached.
  final bool connected;
}
