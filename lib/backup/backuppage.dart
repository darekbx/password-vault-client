import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:passwordvaultclient/storage.dart';
import 'package:passwordvaultclient/security/encryptedstorage.dart';

class BackupPage extends StatefulWidget {
  BackupPage({Key key}) : super(key: key);

  @override
  _BackupState createState() => _BackupState();
}

class _BackupState extends State<BackupPage> {
  final Storage _storage = Storage();
  final _textFieldController = TextEditingController();
  var _statusText = "";

  var _decryptionSample = "ZnJvbSBjcnlwdG9ncmFwaHkuZmVybmV0IGltcG9ydCBGZXJuZXQKaW1wb3J0IGJhc2U2NAoKcGluTWQ1ID0gIjgxZGM5YmRiNTJkMDRkYzIwMDM2ZGJkODMxM2VkMDU1IgpkYXRhRW5jcnlwdGVkID0gImdBQUFBQUJkdHhNOURRMFlDUXNnRHhvRUZnNFNBUUlRQWJ5Z2RLWnhuNjdzUVpiZnFIT2kvNDJkdi82ZjR4dWpBMG41dXY2enBkY0R6REd0OU5LVjNPYjJoN3VOajRxQ2ZGUW4rbjJYR3Z2NXljSzBkREtnWDNNPSIKCmtleSA9IGJhc2U2NC5iNjRlbmNvZGUocGluTWQ1KQpmID0gRmVybmV0KGtleSkKZCA9IGYuZGVjcnlwdChkYXRhRW5jcnlwdGVkKQoKcHJpbnQoZCkK";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Password Vault"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildTextField(),
          _buildStatusText(),
          Expanded(child: Container()),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
            _buildButton("Import", () => import()),
            _buildButton("Export", () => export())
          ]),
        ],
      ),
    );
  }

  Widget _buildTextField() {
    return Container(
        padding: EdgeInsets.all(16),
        child: TextFormField(
          controller: _textFieldController,
          textAlign: TextAlign.start,
          maxLines: null,
          style: TextStyle(fontFamily: 'RobotoMono'),
          decoration:
              InputDecoration(hintText: "", border: OutlineInputBorder()),
        ));
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return Expanded(
        child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 16),
            child: RaisedButton(
                child: Text(text),
                textColor: Colors.white,
                color: Colors.blueGrey,
                onPressed: () => onPressed())));
  }

  Widget _buildStatusText() {
    return Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 16),
        child: Text(_statusText));
  }

  void export() async {
    try {
      var pin = await _storage.readPin();
      var encryptedStorage = EncryptedStorage(pin);
      var data = await encryptedStorage.export();
      data["PythonDecryptionSample"] = _decryptionSample;
      var dataJson = json.encode(data);
      _textFieldController.text = dataJson;
      setState(() {
        _statusText = "Data exported";
      });
    } catch (e) {
      setState(() {
        _statusText = "Export error: $e";
      });
    }
  }

  Future import() async {
    var dataJson = _textFieldController.text;
    if (dataJson.isNotEmpty) {
      try {
        var data = json.decode(dataJson);
        var pin = await _storage.readPin();
        var encryptedStorage = EncryptedStorage(pin);
        await encryptedStorage.import(data);
        setState(() {
          _statusText = "Data was imported";
        });
      } catch (e) {
        setState(() {
          _statusText = "Import error: $e";
        });
      }
    } else {
      setState(() {
        _statusText = "Text field is empty";
      });
    }
  }
}
