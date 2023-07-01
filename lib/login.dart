import 'package:flutter/material.dart';
import 'package:shrine/utils/sign_in_method.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/thug_logo.png',
                height: size.height * 0.25,
                width: size.width * 0.65,
              ),
              const SizedBox(height: 64.0),
              const GoogleSigninButton(),
              SizedBox(height: 24),
              AnonymousSigninButton(),
            ],
          ),
        ),
      ),
    );
  }
}
