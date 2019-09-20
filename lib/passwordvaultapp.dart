import 'package:flutter/material.dart';

import 'authorize/authorizepage.dart';

class PasswordVaultApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Password Vault',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: AuthorizePage(),
    );
  }
}