import 'package:flutter/material.dart';

class AuthorizePage extends StatefulWidget {
  AuthorizePage({Key key}) : super(key: key);

  @override
  _AuthorizePageState createState() => _AuthorizePageState();
}

class _AuthorizePageState extends State<AuthorizePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Password Vault - Authorize"),
      ),
      body: _displayAuthRequest(),
    );
  }

  Widget _displayAuthRequest() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.fingerprint, size: 75.0),
          Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(children: <Widget>[
                Text('Please authorize with fingerprint', textScaleFactor: 1.1),
                InkWell(
                    child: Text('Or enter PIN',
                        textScaleFactor: 1.1,
                        style: TextStyle(decoration: TextDecoration.underline)),
                    onTap: _onPinTap)
              ]))
        ],
      ),
    );
  }

  void _onPinTap() {}
}
