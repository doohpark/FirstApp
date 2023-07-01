import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  var usernameRegExp = RegExp(
      r'^(?=.*[A-Za-z].*[A-Za-z].*[A-Za-z])(?=.*\d.*\d.*\d)[A-Za-z\d]{6,}$');

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future(() => false);
      },
      child: Scaffold(
        body: SafeArea(
          // Form
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              children: <Widget>[
                const SizedBox(height: 80.0),

                // Username
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: 'Username',
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !usernameRegExp.hasMatch(value)) {
                      return 'Username is invaild';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12.0),

                // Password
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: 'Password',
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12.0),

                // Confirm Password
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: 'Confirm Password',
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        _confirmPasswordController.text !=
                            _passwordController.text) {
                      return 'Confirm Password doesn\'t match Password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12.0),

                // Email Address
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: 'Email Address',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Email Address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12.0),

                // Buttons
                OverflowBar(
                  alignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')),
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('SIGN UP'),
                    ),
                    const SizedBox(width: 12.0),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
