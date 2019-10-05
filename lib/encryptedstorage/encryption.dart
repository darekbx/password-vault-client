import 'package:encrypt/encrypt.dart';
import 'dart:convert';

class Encryption {

  String salt;

  Encryption(this.salt);

  List<String> listKeys() {
    return null;
  }

  void save(String key, String value) {
    final encrypted = encrypt(value);
    // TODO: save to file
  }

  String read(String key) {
    // TODO: read from file
  }

  String encrypt(String rawValue) {
    final encrypter = _createEncrypter();
    final encrypted = encrypter.encrypt(rawValue);
    return encrypted.base64;
  }

  String decrypt(String value) {
    final encrypter = _createEncrypter();
    return encrypter.decrypt64(value);
  }

  Encrypter _createEncrypter() {
    final key = Key.fromUtf8(this.salt);
    final b64key = Key.fromUtf8(base64Url.encode(key.bytes));
    final fernet = Fernet(b64key);
    return Encrypter(fernet);
  }
}