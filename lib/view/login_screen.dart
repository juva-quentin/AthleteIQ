import 'package:athlete_iq/resources/colors.dart';
import 'package:athlete_iq/resources/size.dart';
import 'package:athlete_iq/utils/EmailVAlidator.dart';
import 'package:athlete_iq/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/riverpods/auth_pod.dart';
import '../data/riverpods/hive_pod.dart';
import '../resources/components/authTextField.dart';
import '../resources/components/authTextPassField.dart';
import '../resources/components/round_button.dart';
import '../utils/routes/routes_name.dart';
import 'onboarding_screen.dart';

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
    ref.read(hiveProvider);
  }

  final ValueNotifier _obscurePassword = ValueNotifier<bool>(true);
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    _obscurePassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final hive = ref.watch(hiveProvider);
    final AppSize appSize = AppSize(context);
    final height = appSize.globalHeight;
    final width = appSize.globalWidth;
    var loading = false;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(children: [
            Container(
              height: height * .30,
              width: width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),
                  color: AppColors.blueColor),
              child: Padding(
                padding:
                    EdgeInsets.only(left: (width * .05), bottom: (width * .06)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset("assets/images/logo.png", height: height * .15),
                    SizedBox(
                      height: height * .01,
                    ),
                    const Text(
                      'Bienvenue,',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Connectez-vous pour continuer,',
                      style: TextStyle(
                          color: Color.fromARGB(156, 35, 109, 178),
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          ]),
          SizedBox(
            height: height * .05,
          ),
          AuthTextField(
            controller: _emailController,
            focusNode: emailFocusNode,
            keyboardType: TextInputType.emailAddress,
            hintText: 'Email',
            labelText: 'Email',
            prefixIcon: const Icon(Icons.alternate_email),
            nextFocus: passwordFocusNode,
          ),
          ValueListenableBuilder(
              valueListenable: _obscurePassword,
              builder: (context, value, child) {
                return AuthTextPassField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    focusNode: passwordFocusNode,
                    keyboardType: TextInputType.text,
                    hintText: 'Mot de passe',
                    labelText: 'Mot de passe',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: InkWell(
                      onTap: () {
                        _obscurePassword.value = !_obscurePassword.value;
                      },
                      child: Icon(
                          _obscurePassword.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility
                      ),
                    ),
                    nextFocus: passwordFocusNode,
                );
              }),
          SizedBox(
            height: height * .08,
          ),
          RoundButton(
            loading: loading,
            title: 'Connexion',
            onPress: () async {
              if (_emailController.text.isEmpty) {
                Utils.flushBarErrorMessage('Veuiller entrer un email', context);
              } else if (!_emailController.text.isValidEmail()) {
                Utils.flushBarErrorMessage(
                    'Veuiller entrer un email valide', context);
              } else if (_passwordController.text.isEmpty) {
                Utils.flushBarErrorMessage(
                    'Veuiller entrer votre mot de passe', context);
              } else if (_passwordController.text.length < 6) {
                Utils.flushBarErrorMessage(
                    'Le mot de passe doit contenir plus de 6 caractères',
                    context);
              } else {
                bool firstTimeState = true;
                firstTimeState = await hive.getHiveData('firstTime') ?? true;
                try {
                  setState(() {
                    loading = true;
                  });
                  await Future.delayed(const Duration(seconds: 5));
                  await auth
                      .loginUserWithFirebase(
                          _emailController.text, _passwordController.text)
                      .then((value) {
                    loading = false;
                    firstTimeState
                        ? Navigator.pushNamed(context, RoutesName.onboarding)
                        : Navigator.pushNamed(context, RoutesName.app);
                  });
                } on FirebaseAuthException catch (e) {
                  // ignore: use_build_context_synchronously
                  Utils.flushBarErrorMessage(e.message!, context);
                }
              }
            },
          ),
          SizedBox(
            height: height * .02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Vous n'avez pas de compte ?"),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, RoutesName.signup);
                },
                child: const Text(
                  "Inscription",
                  style: TextStyle(color: Color.fromARGB(255, 0, 152, 240)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
