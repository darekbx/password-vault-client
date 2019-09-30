import 'package:flutter/material.dart';
import 'package:biometric/biometric.dart';
import 'package:flutter/services.dart';

enum _State {
  NOT_AUTHENTICATED,
  NOT_AVAILABLE,
  AUTHENTICATION_FAILED,
  AUTHENTICATED,
  ENTER_PIN
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
git 
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
        body = _displayAuthWidget();
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
      case _State.ENTER_PIN:
        body =_enterPin();
        break;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Password Vault - Authorize"),
      ),
      body: body,
    );
  }

  Widget _errorMessage(String message) => _authWidget(message, "Retry", _retryAuthentication, color: Colors.redAccent);
  Widget _displayAuthWidget() => _authWidget('Please authorize with fingerprint', "Or enter PIN", _onPinTap);

  Widget _authWidget(String title, String linkedMessage, Function callback, {Color color = Colors.black}) {
    return Center(
        child: Card(
            elevation: 3.0,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.fingerprint, size: 75.0, color: color),
                  Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(children: <Widget>[
                        Text(title,
                            textScaleFactor: 1.1,
                            style: TextStyle(color: color)),
                        InkWell(
                            child: Text(linkedMessage,
                                textScaleFactor: 1.1,
                                style: TextStyle(
                                    decoration: TextDecoration.underline)),
                            onTap: callback)
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

  Widget _enterPin() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //Icon(Icons.fingerprint, size: 75.0),
          Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  for (var i = 0; i < 4; i++)
                    Container(width: 44, child: TextFormField(
                      maxLength: 1,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(16),
                        border: OutlineInputBorder(),
                        counterText: ''
                      ),
                    ))
                
              ]))
        ],
      ),
    );
  }

  void _onPinTap() {
    setState(() {
      _authState = _State.ENTER_PIN;
    });
  }
}
