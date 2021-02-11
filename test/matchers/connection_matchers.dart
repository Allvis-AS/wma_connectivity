import 'package:test/test.dart';
import 'package:wma_connectivity/wma_connectivity.dart';

final isConnected =
    predicate<List<Connection>>((c) => c.single.connected, 'is connected');
final isNotConnected = isNot(isConnected);
