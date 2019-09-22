import 'package:flutter/material.dart';
import 'package:biometric/biometric.dart';
import 'package:flutter/services.dart';

class AuthorizePage extends StatefulWidget {
  AuthorizePage({Key key}) : super(key: key);

  @override
  _AuthorizePageState createState() => _AuthorizePageState();
}

class _AuthorizePageState extends State<AuthorizePage> {
  final Biometric _biometric = Biometric();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      _initializeBiometric();
    });
  }

  Future<void> _initializeBiometric() async {
    bool authResult = false;
    bool authAvailable;

    try {
      authAvailable = await _biometric.biometricAvailable();
    } on PlatformException catch (e) {
      print(e);
    }

    if (authAvailable) {
      String errorMessage = "";
      String errorCode = "";
      try {
        authResult = await _biometric.biometricAuthenticate(keepAlive: true);
      } on PlatformException catch (e) {
        errorMessage = e.message.toString();
        errorCode = e.message.toString();
      }

      if (mounted) {
        if (authResult) {
          // Authenticated

        } else {
          // Failed
        }
      }
    }
  }

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
