import 'package:athlete_iq/resources/components/authTextPassField.dart';
import 'package:athlete_iq/utils/EmailVAlidator.dart';
import 'package:athlete_iq/utils/routes/routes_name.dart';
import 'package:athlete_iq/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gender_selection/gender_selection.dart';

import '../data/riverpods/auth_pod.dart';
import '../data/riverpods/hive_pod.dart';
import '../resources/colors.dart';
import '../resources/components/authTextField.dart';
import '../resources/components/round_button.dart';
import '../resources/size.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(authProvider);
    ref.read(hiveProvider);
  }

  late String selectGender = '';
  final ValueNotifier _obscurePassword = ValueNotifier<bool>(true);
  final ValueNotifier _obsecureValidePassword = ValueNotifier<bool>(true);
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _validePasswordController =
      TextEditingController();

  FocusNode emailFocusNode = FocusNode();
  FocusNode nameFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode validePasswordFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _validePasswordController.dispose();
    nameFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    validePasswordFocusNode.dispose();
    _obscurePassword.dispose();
    _obsecureValidePassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final hive = ref.watch(hiveProvider);
    final AppSize appSize = AppSize(context);
    final height = appSize.globalHeight;
    final width = appSize.globalWidth;
    return Scaffold(
      resizeToAvoidBottomInset : false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(children: [
            Container(
              height: height * .30,
              width: width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(35), bottomLeft: Radius.circular(35)),
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
                      'Inscrivez-vous pour continuer,',
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
          Column(
            children: [
              AuthTextField(
                controller: _nameController,
                focusNode: nameFocusNode,
                keyboardType: TextInputType.name,
                hintText: 'Pseudo',
                labelText: 'Pseudo',
                prefixIcon: const Icon(Icons.account_circle_outlined),
                nextFocus: emailFocusNode,
              ),
              AuthTextField(
                controller: _emailController,
                focusNode: emailFocusNode,
                keyboardType: TextInputType.emailAddress,
                hintText: 'Email',
                labelText: 'Email',
                prefixIcon: const Icon(Icons.alternate_email),
                nextFocus: passwordFocusNode
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
                      nextFocus: validePasswordFocusNode
                    );
                  }),
              ValueListenableBuilder(
                  valueListenable: _obsecureValidePassword,
                  builder: (context, value, child) {
                    return AuthTextPassField(
                        controller: _validePasswordController,
                        obscureText: _obsecureValidePassword,
                        focusNode: validePasswordFocusNode,
                        keyboardType: TextInputType.text,
                        hintText: 'Mot de passe',
                        labelText: 'Mot de passe',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: InkWell(
                          onTap: () {
                            _obsecureValidePassword.value =
                            !_obsecureValidePassword.value;
                          },
                          child: Icon(_obsecureValidePassword.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility),
                        ),
                        nextFocus: validePasswordFocusNode
                    );
                  }),
              SizedBox(
                height: height * .01,
              ),
              Container(
                alignment: Alignment.center,
                child: GenderSelection(
                  linearGradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment(0.8, 1),
                    colors: <Color>[
                      Color(0xff1f005c),
                      Color.fromARGB(255, 35, 23, 163),
                      Color.fromARGB(255, 52, 1, 135),
                      Color.fromARGB(255, 71, 37, 172),
                      Color.fromARGB(255, 102, 72, 202),
                      Color.fromARGB(255, 132, 92, 225),
                      Color.fromARGB(255, 147, 96, 243),
                      Color.fromARGB(255, 149, 103, 213),
                    ],
                  ),
                  maleText: "Homme",
                  femaleText: "Femme",
                  selectedGenderIconBackgroundColor: Colors.indigo,
                  checkIconAlignment: Alignment.centerRight,
                  onChanged: (Gender gender) {
                    if (gender == Gender.Male) {
                      selectGender = 'Homme';
                    } else {
                      selectGender = 'Femme';
                    }
                  },
                  maleImage: const AssetImage("assets/images/IMG_3372.PNG"),
                  femaleImage: const AssetImage("assets/images/IMG_1269.jpeg"),
                  equallyAligned: true,
                  animationDuration: const Duration(milliseconds: 400),
                  isCircular: true,
                  isSelectedGenderIconCircular: true,
                  opacityOfGradient: 0.6,
                  padding: const EdgeInsets.all(3),
                  size: height * .1,
                ),
              ),
              SizedBox(
                height: height * .015,
              ),
              RoundButton(
                title: 'Inscription',
                onPress: () async {
                  if (_nameController.text.isEmpty) {
                    Utils.flushBarErrorMessage(
                        'Veuiller entrer un pseudo', context);
                  } else if (_emailController.text.isEmpty) {
                    Utils.flushBarErrorMessage(
                        'Veuiller entrer un email', context);
                  } else if (!_emailController.text.isValidEmail()) {
                    Utils.flushBarErrorMessage(
                        'Veuiller entrer un email valide', context);
                  } else if (_passwordController.text.isEmpty) {
                    Utils.flushBarErrorMessage(
                        'Veuiller entrer votre mot de passe', context);
                  } else if (_validePasswordController.text.isEmpty) {
                    Utils.flushBarErrorMessage(
                        'Veuiller valider votre mot de passe', context);
                  } else if (_passwordController.text !=
                      _validePasswordController.text) {
                    Utils.flushBarErrorMessage(
                        'Les mots de passe ne correspondent pas', context);
                  } else if (_passwordController.text.length < 6) {
                    Utils.flushBarErrorMessage(
                        'Le mot de passe doit contenir plus de 6 caractères',
                        context);
                  } else if (selectGender.isEmpty) {
                    Utils.flushBarErrorMessage(
                        'Veuiller selectionner votre genre', context);
                  } else {
                    bool firstTimeState = true;
                    firstTimeState =
                        await hive.getHiveData('firstTime') ?? true;
                    try {
                      await auth
                          .signupUserWithFirebase(
                              _emailController.text,
                              _passwordController.text,
                              _nameController.text,
                              selectGender)
                          .then((value) {
                        firstTimeState
                            ? Navigator.pushNamed(
                                context, RoutesName.onboarding)
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
                  const Text("Vous avez un compte ?"),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, RoutesName.login);
                    },
                    child: const Text(
                      "Connexion",
                      style: TextStyle(color: Color.fromARGB(255, 0, 152, 240)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
