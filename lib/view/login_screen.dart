import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(children: [
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          focusNode: emailFocusNode,
          decoration: InputDecoration(
              hintText: 'Email',
              labelText: 'Email',
              prefixIcon: Icon(Icons.alternate_email)),
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(passwordFocusNode);
          },
        ),
        TextFormField(
          controller: _passwordController,
          obscureText: true,
          focusNode: passwordFocusNode,
          decoration: InputDecoration(
              hintText: 'Password',
              labelText: 'Password',
              prefixIcon: Icon(Icons.alternate_email),
              suffixIcon: Icon(Icons.visibility_off_outlined)),
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus();
          },
        )
      ]),
    ));
  }
}
