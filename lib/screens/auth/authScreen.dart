import 'package:flutter/material.dart';

import 'authForm.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({ Key? key }) : super(key: key);

  @override
  _AuthScrreenState createState() => _AuthScrreenState();
}

class _AuthScrreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Authentication"),
        
      ),
      body: AuthForm(),
    );
  }
}