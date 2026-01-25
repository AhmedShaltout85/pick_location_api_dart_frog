import 'package:redis/redis.dart';

Future<void> main() async {
  try {
    print('Attempting to connect to Redis...');

    final connection = RedisConnection();
    final command = await connection.connect('localhost', 6379);

    print('Connection established!');

    final result = await command.send_object(['PING']);
    print('PING result: $result');

    await command.send_object(['SET', 'test_key', 'test_value']);
    print('SET successful');

    final value = await command.send_object(['GET', 'test_key']);
    print('GET result: $value');

    connection.close();
    print('✓ All tests passed!');
  } catch (e, stackTrace) {
    print('✗ Error: $e');
    print('Stack trace: $stackTrace');
  }
}
