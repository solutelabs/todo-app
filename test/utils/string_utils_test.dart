import 'package:shared_code/shared_code.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  test('Email validation', () {
    expect(isEmailValid('milind.mevada@solutelabs.com'), equals(true));
    expect(isEmailValid(null), equals(false));
    expect(isEmailValid('   '), equals(false));
    expect(isEmailValid('milind.mevadasolutelabs.com'), equals(false));
    expect(isEmailValid('milind.mevada345@solutelabs.com'), equals(true));
  });
}
