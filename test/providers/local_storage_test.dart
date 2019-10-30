import 'package:checklist/providers/local_storage_provider.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  test('Should return saved token, even by new instance', () async {
    await InMemoryStorage().saveToken('token');
    final token = await InMemoryStorage().getToken();
    expectLater(token, equals('token'));
  });

  test('Should return saved userId, even by new instance', () async {
    await InMemoryStorage().saveUserId('user_id');
    final userId = await InMemoryStorage().getUserId();
    expectLater(userId, equals('user_id'));
  });
}
