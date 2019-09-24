import 'package:flutter/material.dart';
import 'package:biometric/biometric.dart';
import 'package:flutter/services.dart';

enum _State {
  NOT_AUTHENTICATED,
  NOT_AVAILABLE,
  AUTHENTICATION_FAILED,
  AUTHENTICATED
}

class AuthorizePage extends StatefulWidget {
  AuthorizePage({Key key}) : super(key: key);

  @override
  _AuthorizePageState createState() => _AuthorizePageState();
}

class _AuthorizePageState extends State<AuthorizePage> {
  final Biometric _biometric = Biometric();
  _State _authState = _State.NOT_AUTHENTICATED;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      _initializeBiometric();
    });
  }

  Future<void> _initializeBiometric() async {
    bool authAvailable = false;

    try {
      authAvailable = await _biometric.biometricAvailable();
    } on PlatformException catch (e) {
      print(e);
    }

    if (authAvailable) {
      bool result = false;
      try {
        result = await _biometric.biometricAuthenticate(keepAlive: true);
      } on PlatformException catch (e) {
        print(e);
      }

      if (mounted) {
        setState(() {
          _authState =
              result ? _State.AUTHENTICATED : _State.AUTHENTICATION_FAILED;
        });
      }
    } else {
      setState(() {
        _authState = _State.NOT_AVAILABLE;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    switch (_authState) {
      case _State.NOT_AUTHENTICATED:
        body = _displayAuthRequest();
        break;
      case _State.NOT_AVAILABLE:
        body = _errorMessage("Not available");
        break;
      case _State.AUTHENTICATION_FAILED:
        body = _errorMessage("Authentication failed");
        break;
      case _State.AUTHENTICATED:
        body = Text("Authenticated");
        break;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Password Vault - Authorize"),
      ),
      body: body,
    );
  }

  Widget _displayAuthRequest() {
    return Center(
        child: Card(
            elevation: 3.0,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.fingerprint, size: 75.0),
                  Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(children: <Widget>[
                        Text('Please authorize with fingerprint',
                            textScaleFactor: 1.1),
                        InkWell(
                            child: Text('Or enter PIN',
                                textScaleFactor: 1.1,
                                style: TextStyle(
                                    decoration: TextDecoration.underline)),
                            onTap: _onPinTap)
                      ]))
                ],
              ),
            )));
  }

  Widget _errorMessage(String message) {
    return Center(
        child: Card(
            elevation: 3.0,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.fingerprint, size: 75.0, color: Colors.redAccent),
                  Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(children: <Widget>[
                        Text(message,
                            textScaleFactor: 1.1,
                            style: TextStyle(color: Colors.redAccent)),
                        InkWell(
                            child: Text('Retry',
                                textScaleFactor: 1.1,
                                style: TextStyle(
                                    decoration: TextDecoration.underline)),
                            onTap: _retryAuthentication)
                      ]))
                ],
              ),
            )));
  }

  void _retryAuthentication() {
    setState(() {
      _authState = _State.NOT_AUTHENTICATED;
    });
    Future.delayed(Duration.zero, () {
      _initializeBiometric();
    });
  }

  void _onPinTap() {}
}
