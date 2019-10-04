import 'package:encrypt/encrypt.dart';
import 'dart:convert';

class Encryption {

  List<String> listKeys() {
    return null;
  }

  void save(String key, String rawValue) {
    final encrypter = _createEncrypter();
    final encrypted = encrypter.encrypt(rawValue);
    
    // TODO save key and encrypted value
  }

  String read(String key) {
    final encrypted = "TODO"; // read encrypted value by key

    final encrypter = _createEncrypter();
    return encrypter.decrypt(encrypted);
  }

  Encrypter _createEncrypter() {
    final key = Key.fromUtf8('TODO_KEY');
    final b64key = Key.fromUtf8(base64Url.encode(key.bytes));
    final fernet = Fernet(b64key);
    return Encrypter(fernet);
  }
}