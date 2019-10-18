import 'package:flutter/material.dart';
import 'package:passwordvaultclient/storage.dart';
import 'package:passwordvaultclient/security/encryptedstorage.dart';

class AddSecretPage extends StatefulWidget {
  AddSecretPage({Key key}) : super(key: key);

  @override
  _AddSecretState createState() => _AddSecretState();
}

class _AddSecretState extends State<AddSecretPage> {
  final Storage _storage = Storage();
  EncryptedStorage _encryptedStorage;

  @override
  void initState() {
    super.initState();
    _initializeStorage();
  }

  _initializeStorage() async {
    var pin = await _storage.readPin();
    _encryptedStorage = EncryptedStorage(pin);
  }

  @override
  Widget build(BuildContext context) {
    
    return null;
  }
}