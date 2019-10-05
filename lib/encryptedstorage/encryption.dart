import 'package:encrypt/encrypt.dart';
import 'dart:convert';

class Encryption {

  List<String> listKeys() {
    return null;
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
    final key = Key.fromUtf8('qwertyuiopasdfghjklzxcvbnmqwerfa');
    final b64key = Key.fromUtf8(base64Url.encode(key.bytes));
    final fernet = Fernet(b64key);
    return Encrypter(fernet);
  }
}