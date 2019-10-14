import 'package:flutter/material.dart';
import 'package:passwordvaultclient/storage.dart';
import 'package:passwordvaultclient/security/encryptedstorage.dart';

class KeysListPage extends StatefulWidget {
  KeysListPage({Key key}) : super(key: key);

  @override
  _KeysListState createState() => _KeysListState();
}

class _KeysListState extends State<KeysListPage> {

  final Storage _storage = Storage();
  EncryptedStorage _encryptedStorage;

  @override
  void initState() {
    _initializeStorage(); 
    super.initState();
  }

  _initializeStorage() async {
    var pin = await _storage.readPin();
    _encryptedStorage = EncryptedStorage(pin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Password Vault"),
      ),
      body: _buildList(),
    );
  }

  FutureBuilder _buildList() {
    return FutureBuilder(
            future: _buildKeysFuture(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return _handleFuture(context, snapshot);
            });
  }

  Future<List<String>> _buildKeysFuture() async  => await _encryptedStorage.listKeys();

  Widget _handleFuture(BuildContext context, AsyncSnapshot<List<String>> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
      case ConnectionState.waiting:
        return _buildLoadingView();
      default:
        if (snapshot.hasError) {
          return _buildError(snapshot.error);
        } else {
          if (snapshot.data == null) {
            return _buildError("Error :( ");
          } else {
            return _buildListView(snapshot.data);
          }
        }
    }
  }

  _buildListView(List<String> keys) {

  }

  _buildLoadingView() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  _buildError(String errorMessage) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(errorMessage),
    );
  }
}