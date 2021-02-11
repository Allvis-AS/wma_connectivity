import 'dart:async';

import 'package:test/test.dart';
import 'package:wma_connectivity/wma_connectivity.dart';

import '../../fakes/fake_sensor.dart';
import '../../matchers/connection_matchers.dart';
import '../../matchers/error_matchers.dart';

void main() {
  group('threshold: 0.5', () {
    const tThreshold = 0.5;
    const tWindow = Duration(seconds: 10);
    late FakeSensor sensor;
    late WmaConnectivity sut;

    setUp(() {
      sensor = FakeSensor(tThreshold);
      sut = WmaConnectivity(sensors: [sensor], window: tWindow);
    });

    tearDown(() {
      sut.dispose();
    });

    test('should not eagerly emit', () async {
      // Arrange
      final stream = sut.connections.timeout(const Duration(milliseconds: 1));
      final a1 = expectLater(stream, emitsError(isTimeoutException));
      // Assert
      await Future.wait([a1]);
    });

    test('should be connected', () async {
      // Arrange
      final stream = sut.connections;
      final a1 = expectLater(
          stream,
          emitsInOrder([
            emits(isNotConnected),
            emits(isConnected),
          ]));
      // Act
      await sensor.add(false);
      await sensor.add(true);
      // Assert
      await Future.wait([a1]);
    });

    test('should be disconnected', () async {
      // Arrange
      final stream = sut.connections;
      final a1 = expectLater(
          stream,
          emitsInOrder([
            emits(isConnected),
            emits(isNotConnected),
          ]));
      // Act
      await sensor.add(true);
      await sensor.add(false);
      // Assert
      await Future.wait([a1]);
    });

    test('should be connected (many)', () async {
      // Arrange
      final stream = sut.connections;
      final a1 = expectLater(
          stream,
          emitsInOrder([
            emits(isNotConnected),
            emits(isNotConnected),
            emits(isNotConnected),
            emits(isNotConnected),
            emits(isConnected),
          ]));
      // Act
      await sensor.add(false);
      await sensor.add(false);
      await sensor.add(false);
      await sensor.add(true);
      await sensor.add(true);
      // Assert
      await Future.wait([a1]);
    });

    test('should be disconnected (many)', () async {
      // Arrange
      final stream = sut.connections;
      final a1 = expectLater(
          stream,
          emitsInOrder([
            emits(isNotConnected),
            emits(isNotConnected),
            emits(isNotConnected),
            emits(isNotConnected),
          ]));
      // Act
      await sensor.add(false);
      await sensor.add(false);
      await sensor.add(false);
      await sensor.add(true);
      // Assert
      await Future.wait([a1]);
    });
  });

  group('threshold: 1.0', () {
    const tThreshold = 1.0;
    const tWindow = Duration(seconds: 10);
    late FakeSensor sensor;
    late WmaConnectivity sut;

    setUp(() {
      sensor = FakeSensor(tThreshold);
      sut = WmaConnectivity(sensors: [sensor], window: tWindow);
    });

    tearDown(() {
      sut.dispose();
    });

    test('should be connected', () async {
      // Arrange
      final stream = sut.connections;
      final a1 = expectLater(
          stream,
          emitsInOrder([
            emits(isConnected),
            emits(isConnected),
          ]));
      // Act
      await sensor.add(true);
      await sensor.add(true);
      // Assert
      await Future.wait([a1]);
    });

    test('should be disconnected', () async {
      // Arrange
      final stream = sut.connections;
      final a1 = expectLater(
          stream,
          emitsInOrder([
            emits(isNotConnected),
            emits(isNotConnected),
          ]));
      // Act
      await sensor.add(false);
      await sensor.add(true);
      // Assert
      await Future.wait([a1]);
    });

    test('should be disconnected (many)', () async {
      // Arrange
      final stream = sut.connections;
      final a1 = expectLater(
          stream,
          emitsInOrder([
            emits(isConnected),
            emits(isConnected),
            emits(isConnected),
            emits(isConnected),
            emits(isNotConnected),
          ]));
      // Act
      await sensor.add(true);
      await sensor.add(true);
      await sensor.add(true);
      await sensor.add(true);
      await sensor.add(false);
      // Assert
      await Future.wait([a1]);
    });

    group('window: 10 seconds', () {
      test('should be connected', () async {
        // Arrange
        final stream = sut.connections;
        final a1 = expectLater(
            stream,
            emitsInOrder([
              emits(isConnected),
            ]));
        // Act
        final sub30 = () => DateTime.now().subtract(Duration(seconds: 30));
        await sensor.add(false, sub30());
        await sensor.add(true);
        // Assert
        await Future.wait([a1]);
      });
    });
  });

  group('threshold: 0.01', () {
    const tThreshold = 0.01;
    const tWindow = Duration(seconds: 10);
    late FakeSensor sensor;
    late WmaConnectivity sut;

    setUp(() {
      sensor = FakeSensor(tThreshold);
      sut = WmaConnectivity(sensors: [sensor], window: tWindow);
    });

    tearDown(() {
      sut.dispose();
    });

    test('should be connected', () async {
      // Arrange
      final stream = sut.connections;
      final a1 = expectLater(
          stream,
          emitsInOrder([
            emits(isConnected),
            emits(isConnected),
          ]));
      // Act
      await sensor.add(true);
      await sensor.add(false);
      // Assert
      await Future.wait([a1]);
    });

    test('should be disconnected', () async {
      // Arrange
      final stream = sut.connections;
      final a1 = expectLater(
          stream,
          emitsInOrder([
            emits(isNotConnected),
            emits(isNotConnected),
          ]));
      // Act
      await sensor.add(false);
      await sensor.add(false);
      // Assert
      await Future.wait([a1]);
    });

    test('should be connected (many)', () async {
      // Arrange
      final stream = sut.connections;
      final a1 = expectLater(
          stream,
          emitsInOrder([
            emits(isConnected),
            emits(isConnected),
            emits(isConnected),
            emits(isConnected),
            emits(isConnected),
          ]));
      // Act
      await sensor.add(true);
      await sensor.add(false);
      await sensor.add(false);
      await sensor.add(false);
      await sensor.add(false);
      // Assert
      await Future.wait([a1]);
    });

    group('window: 10 seconds', () {
      test('should be disconnected', () async {
        // Arrange
        final stream = sut.connections;
        final a1 = expectLater(
            stream,
            emitsInOrder([
              emits(isNotConnected),
            ]));
        // Act
        final sub30 = () => DateTime.now().subtract(Duration(seconds: 30));
        await sensor.add(true, sub30());
        await sensor.add(false);
        // Assert
        await Future.wait([a1]);
      });
    });
  });
}
