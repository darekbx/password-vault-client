import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:passwordvaultclient/security/encryption.dart';

class EncryptedStorage {
  Encryption _encryption;

  EncryptedStorage(String salt) {
    var pinMd5 = md5.convert(utf8.encode(salt)).toString();
    _encryption = Encryption(pinMd5);
  }

  String _prefix = "key_";

  Future<List<String>> listKeys() async {
    var preferences = await _providePreferences();
    return preferences.getKeys().where((key) => key.startsWith(_prefix)).toList();
  }

  Future save(String key, String value) async {
    final encrypted = _encryption.encrypt(value);
    var preferences = await _providePreferences();
    await preferences.setString("$_prefix$key", encrypted);
  }

  Future<String> read(String key) async {
    var preferences = await _providePreferences();
    final encrypted = preferences.getString("$_prefix$key");
    return _encryption.decrypt(encrypted);
  }

  Future<SharedPreferences> _providePreferences() async => await SharedPreferences.getInstance();
}