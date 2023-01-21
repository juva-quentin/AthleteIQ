import 'package:athlete_iq/utils/EmailVAlidator.dart';
import 'package:athlete_iq/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/riverpods/auth_pod.dart';
import '../resources/components/round_button.dart';
import '../utils/routes/routes_name.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {

  @override
  void initState() {
    super.initState();
    ref.read(authProvider);
  }


  final ValueNotifier _obsecurePassword = ValueNotifier<bool>(true);
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  @override
  void dispose(){
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    _obsecurePassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final height = MediaQuery.of(context).size.height * 1;
    return Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                focusNode: emailFocusNode,
                decoration: const InputDecoration(
                    hintText: 'Email',
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.alternate_email)),
                onFieldSubmitted: (value) {
                  Utils.fieldFocusChange(
                      context, emailFocusNode, passwordFocusNode);
                },
              ),
              ValueListenableBuilder(
                  valueListenable: _obsecurePassword,
                  builder: (context, value, child) {
                    return TextFormField(
                      controller: _passwordController,
                      obscureText: _obsecurePassword.value,
                      focusNode: passwordFocusNode,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: InkWell(
                          onTap: () {
                            _obsecurePassword.value == !_obsecurePassword.value;
                          },
                          child: Icon(_obsecurePassword.value ? Icons.visibility_off_outlined : Icons.visibility),
                        ),
                      ),
                    );
                  }),
              SizedBox(height: height * .1,),
              RoundButton(
                title: 'Connexion',
                onPress: () {
                  if(_emailController.text.isEmpty){
                    Utils.flushBarErrorMessage('Veuiller entrer un email', context);
                  }else if (!_emailController.text.isValidEmail()){
                    Utils.flushBarErrorMessage('Veuiller entrer un email valide', context);
                  }else if (_passwordController.text.isEmpty){
                    Utils.flushBarErrorMessage('Veuiller entrer votre mot de passe', context);
                  }else if(_passwordController.text.length < 6){
                    Utils.flushBarErrorMessage('Le mot de passe doit contenir plus de 6 caractères', context);
                  }else{
                    auth.loginUserWithFirebase(_emailController.text, _passwordController.text).then((value){
                      Navigator.pushNamed(context, RoutesName.home);
                    });
                  }
                },
              ),
              SizedBox(height: height * .1,),
              InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, RoutesName.signup);
                  },
                  child:Text("Signup")
              )
            ]),
        ),
    );
  }
}
