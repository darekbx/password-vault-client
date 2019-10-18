import 'package:flutter/material.dart';
import 'package:passwordvaultclient/storage.dart';
import 'package:passwordvaultclient/security/encryptedstorage.dart';

class AddSecretPage extends StatefulWidget {
  AddSecretPage({Key key}) : super(key: key);

  @override
  _AddSecretState createState() => _AddSecretState();
}

class _AddSecretState extends State<AddSecretPage> {
  final _keyController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordRepeatController = TextEditingController();

  final _passwordFocusNode = FocusNode();
  final _passwordRepeatFocusNode = FocusNode();

  final Storage _storage = Storage();
  EncryptedStorage _encryptedStorage;

  var passwordVisible = false;

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
    return Scaffold(
        appBar: AppBar(
          title: Text("Password Vault - Add Secret"),
        ),
        body: _buildForm());
  }

  Widget _buildForm() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _buildKeyField(_keyController, "Secret key"),
          _buildPasswordField(_passwordController, "Enter secret", false),
          _buildPasswordField(_passwordRepeatController, "Repeat secret", true),
          _buildSaveButton()
        ],
      ),
    );
  }

  Widget _buildKeyField(TextEditingController controller, String hint) {
    return Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: TextFormField(
            controller: controller,
            onFieldSubmitted: (field) {
              FocusScope.of(context).requestFocus(_passwordFocusNode);
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(16),
                border: OutlineInputBorder(),
                hintText: hint)));
  }

  Widget _buildPasswordField(
      TextEditingController controller, String hint, bool isRepeat) {
    return Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: TextFormField(
            controller: controller,
            focusNode: isRepeat ? _passwordRepeatFocusNode : _passwordFocusNode,
            obscureText: passwordVisible,
            onFieldSubmitted: (field) {
              if (!isRepeat) {
                FocusScope.of(context).requestFocus(_passwordRepeatFocusNode);
              }
            },
            textInputAction:
                isRepeat ? TextInputAction.none : TextInputAction.next,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(16),
                border: OutlineInputBorder(),
                hintText: hint,
                suffixIcon: IconButton(
                  icon: Icon(
                    passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  onPressed: () {
                    setState(() {
                      passwordVisible = !passwordVisible;
                    });
                  },
                ))));
  }

  Widget _buildSaveButton() {
    return Expanded(
        child: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  child: Text("Save"),
                  textColor: Colors.white,
                  color: Colors.blueGrey,
                  onPressed: () {},
                ))));
  }
}
