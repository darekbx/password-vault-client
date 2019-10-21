import 'package:flutter/material.dart';
import 'package:passwordvaultclient/storage.dart';
import 'package:passwordvaultclient/security/encryptedstorage.dart';

class SecretPage extends StatefulWidget {
  SecretPage({Key key, this.secretKey}) : super(key: key);

  final String secretKey;

  @override
  _SecretState createState() => _SecretState();
}

class _SecretState extends State<SecretPage> {
  final _passwordController = TextEditingController();
  final Storage _storage = Storage();

  var _passwordNotVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Password Vault - Secret"),
        ),
        body: _buildPreview());
  }

  Widget _buildPreview() {
    return Center(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
        _buildKey(),
        FutureBuilder<String>(
            future: _buildPasswordFuture(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              return _handleFuture(context, snapshot);
            })
      ],
    ));
  }

  Widget _buildKey() {
    return Text(widget.secretKey, style: TextStyle(fontSize: 28));
  }

  Future<String> _buildPasswordFuture() async {
    var pin = await _storage.readPin();
    EncryptedStorage encryptedStorage = EncryptedStorage(pin);
    return await encryptedStorage.read(widget.secretKey);
  }

  Widget _handleFuture(BuildContext context, AsyncSnapshot<String> snapshot) {
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
            if (snapshot.data.isEmpty) {
              return _buildEmptyView();
            } else {
              return _buildSecretView(snapshot.data);
            }
          }
        }
    }
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

  Widget _buildEmptyView() {
    return Center(child: Text("The secret is empty."));
  }

  Widget _buildSecretView(String secret) {
    _passwordController.text = secret;
    return Container(
      width: 250,
      child: Padding(
        padding: EdgeInsets.only(top: 16),
        child: TextFormField(
        controller: _passwordController,
        obscureText: _passwordNotVisible,
        readOnly: true,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(16),
            border: OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(
                _passwordNotVisible ? Icons.visibility : Icons.visibility_off,
                color: Theme.of(context).primaryColorDark,
              ),
              onPressed: () {
                setState(() {
                  _passwordNotVisible = !_passwordNotVisible;
                });
              },
            )))));
  }
}
