import 'package:flutter/material.dart';
import 'package:passwordvaultclient/storage.dart';
import 'package:passwordvaultclient/security/encryptedstorage.dart';
import 'package:passwordvaultclient/vault/addsecretpage.dart';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Password Vault"),
      ),
      body: _buildList(),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            _addSecret();
          }),
    );
  }

  FutureBuilder _buildList() {
    return FutureBuilder<List<String>>(
        future: _buildKeysFuture(),
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          return _handleFuture(context, snapshot);
        });
  }

  Future<List<String>> _buildKeysFuture() async {
    var pin = await _storage.readPin();
    _encryptedStorage = EncryptedStorage(pin);
    return await _encryptedStorage.listKeys();
  }

  Widget _handleFuture(
      BuildContext context, AsyncSnapshot<List<String>> snapshot) {
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

  Widget _buildListView(List<String> keys) {
    return ListView.builder(
        itemCount: keys.length,
        itemBuilder: (context, index) => _buildListItem(keys[index]));
  }

  Widget _buildListItem(String key) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.only(left: 8, top: 8, right: 8),
        child: Wrap(
          direction: Axis.horizontal,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            Padding(padding: EdgeInsets.all(8), child: Icon(Icons.vpn_key)),
            Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  key,
                  style: TextStyle(fontSize: 18),
                ))
          ],
        ),
      ),
      onTap: () {},
    );
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

  _addSecret() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddSecretPage()));
  }
}
