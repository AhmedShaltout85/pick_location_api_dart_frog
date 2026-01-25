import 'package:mocktail/mocktail.dart';
import 'package:pick_location_api/models/location.dart';
import 'package:pick_location_api/repositories/location_repository.dart';
import 'package:pick_location_api/services/redis_service.dart';
import 'package:test/test.dart';

class MockRedisService extends Mock implements RedisService {}

class MockLocationRepository extends Mock implements LocationRepository {}

void main() {
  group('Location Routes with Redis', () {
    late RedisService mockRedis;
    late LocationRepository mockRepo;

    setUp(() {
      mockRedis = MockRedisService();
      mockRepo = MockLocationRepository();
    });

    test('GET /locations returns cached data when available', () async {
      // Arrange
      final cachedLocations = [
        {
          'id': 1,
          'address': 'Test Address',
          'latitude': '30.0',
          'longitude': '31.0',
        }
      ];

      when(() => mockRedis.getJsonList('locations:all'))
          .thenAnswer((_) async => cachedLocations);

      // Act & Assert
      // Your test logic here

      verify(() => mockRedis.getJsonList('locations:all')).called(1);
      verifyNever(() => mockRepo.findAll());
    });

    test('GET /locations fetches from DB when cache is empty', () async {
      // Arrange
      when(() => mockRedis.getJsonList('locations:all'))
          .thenAnswer((_) async => null);

      final locations = [
        Location(
          address: 'Test',
          latitude: '30.0',
          longitude: '31.0',
          date: DateTime.now(),
        ),
      ];

      when(() => mockRepo.findAll()).thenAnswer((_) async => locations);
      when(
        () => mockRedis.setJsonList(
          any(),
          any(),
          expirySeconds: any(named: 'expirySeconds'),
        ),
      ).thenAnswer((_) async => {});

      // Act & Assert
      verify(() => mockRedis.getJsonList('locations:all')).called(1);
      verify(() => mockRepo.findAll()).called(1);
      verify(
        () => mockRedis.setJsonList('locations:all', any(), expirySeconds: 300),
      ).called(1);
    });

    test('POST /locations invalidates cache', () async {
      // Arrange
      when(() => mockRedis.delete(any())).thenAnswer((_) async => {});
      when(() => mockRedis.deletePattern(any())).thenAnswer((_) async => {});

      // Act & Assert
      verify(() => mockRedis.delete(['locations:all'])).called(1);
      verify(() => mockRedis.delete(['locations:pending'])).called(1);
      verify(() => mockRedis.deletePattern('locations:handasah:*')).called(1);
    });
  });
}
