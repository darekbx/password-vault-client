import 'package:flutter/material.dart';

class BackupPage extends StatefulWidget {
  BackupPage({Key key, this.mode}) : super(key: key);

  final int mode;

  @override
  _BackupState createState() => _BackupState();
}

class _BackupState extends State<BackupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Password Vault"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 8),
          Expanded(
              child: Container(
                  padding: EdgeInsets.all(16),
                  child: TextFormField(
                    textAlign: TextAlign.start,
                    maxLines: null,
                    expands: true,
                    decoration: InputDecoration(
                      hintText: "",
                      border: OutlineInputBorder()
                    ),
                  ))),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
            Expanded(
                child: Padding(
                    padding: EdgeInsets.only(left:16, right:8, top:4, bottom:16),
                    child: RaisedButton(
                      child: Text("Import"),
                      onPressed: () {},
                    ))),
            Expanded(
                child: Padding(
                    padding: EdgeInsets.only(left:8, right:16, top:4, bottom:16),
                    child:
                        RaisedButton(child: Text("Export"), onPressed: () {}))),
          ]),
        ],
      ),
    );
  }
}
