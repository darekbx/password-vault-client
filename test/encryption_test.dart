// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import "package:test/test.dart";

import 'package:passwordvaultclient/encryptedstorage/encryption.dart';

// flutter pub run test ./test/encryption_test.dart

void main() {
  test('Encrypt / Decrypt', () {
    var input = "p@ssw0rd";
    var encryption = Encryption();

    var encrypted = encryption.encrypt(input);
    var decrypted = encryption.decrypt(encrypted);

    expect(input, decrypted);
  });
}
