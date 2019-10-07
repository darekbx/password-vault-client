import "package:test/test.dart";

import 'package:passwordvaultclient/security/encryption.dart';

// flutter pub run test ./test/encryption_test.dart
void main() {
  var testSalt = "hyikvztwyjuyfyhikkmuydalwrimjffr";

  test('Encrypt / Decrypt', () {
    var input = "p@ssw0rd";
    var encryption = Encryption(testSalt);

    var encrypted = encryption.encrypt(input);
    var decrypted = encryption.decrypt(encrypted);

    expect(input, decrypted);
  });
}
