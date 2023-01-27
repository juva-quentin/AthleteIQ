import 'package:athlete_iq/utils/EmailVAlidator.dart';
import 'package:athlete_iq/utils/routes/routes_name.dart';
import 'package:athlete_iq/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gender_selection/gender_selection.dart';

import '../data/riverpods/auth_pod.dart';
import '../data/riverpods/hive_pod.dart';
import '../resources/components/round_button.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({Key? key}): super(key: key);

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
  final ValueNotifier _obsecurePassword = ValueNotifier<bool>(true);
  final ValueNotifier _obsecureValidePassword = ValueNotifier<bool>(true);
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _validePasswordController = TextEditingController();


  FocusNode emailFocusNode = FocusNode();
  FocusNode nameFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode validePasswordFocusNode = FocusNode();



  @override
  void dispose(){
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _validePasswordController.dispose();
    nameFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    validePasswordFocusNode.dispose();
    _obsecurePassword.dispose();
    _obsecureValidePassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final hive = ref.watch(hiveProvider);
    final height = MediaQuery.of(context).size.height * 1;
    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    focusNode: nameFocusNode,
                    decoration: const InputDecoration(
                        hintText: 'Pseudo',
                        labelText: 'Pseudo',
                        prefixIcon: Icon(Icons.account_circle_outlined)),
                    onFieldSubmitted: (value) {
                      Utils.fieldFocusChange(
                          context, nameFocusNode, emailFocusNode);
                    },
                  ),
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
                                _obsecurePassword.value = !_obsecurePassword.value;
                              },
                              child: Icon(_obsecurePassword.value ? Icons.visibility_off_outlined : Icons.visibility),
                            ),
                          ),
                          onFieldSubmitted: (value) {
                            Utils.fieldFocusChange(
                                context, passwordFocusNode, validePasswordFocusNode);
                          },
                        );
                      }),
                  ValueListenableBuilder(
                      valueListenable: _obsecureValidePassword,
                      builder: (context, value, child) {
                        return TextFormField(
                          controller: _validePasswordController,
                          obscureText: _obsecureValidePassword.value,
                          focusNode: validePasswordFocusNode,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: InkWell(
                              onTap: () {
                                _obsecureValidePassword.value = !_obsecureValidePassword.value;
                              },
                              child: Icon(_obsecureValidePassword.value ? Icons.visibility_off_outlined : Icons.visibility),
                            ),
                          ),
                        );
                      }),
            Container(
              margin: EdgeInsets.symmetric(vertical: 40),
              alignment: Alignment.center,
              child: GenderSelection(
                maleText: "Homme", //default Male
                femaleText: "Femme", //default Female
                selectedGenderIconBackgroundColor: Colors.indigo, // default red
                checkIconAlignment: Alignment.centerRight,   // default bottomRight
                onChanged: (Gender gender){
                  if (gender == Gender.Male){
                    selectGender = 'Homme';
                  }else{
                    selectGender = 'Femme';
                  }
                },
                equallyAligned: true,
                animationDuration: Duration(milliseconds: 400),
                isCircular: true, // default : true,
                isSelectedGenderIconCircular: true,
                opacityOfGradient: 0.6,
                padding: const EdgeInsets.all(3),
                size: 120, //default : 120
              ),
            ),
                  SizedBox(height: height * .1,),
                  RoundButton(
                    title: 'Inscription',
                    onPress: () async {
                      if(_nameController.text.isEmpty) {
                        Utils.flushBarErrorMessage('Veuiller entrer un pseudo', context);
                      }else if(_emailController.text.isEmpty){
                        Utils.flushBarErrorMessage('Veuiller entrer un email', context);
                      }else if (!_emailController.text.isValidEmail()){
                        Utils.flushBarErrorMessage('Veuiller entrer un email valide', context);
                      }else if (_passwordController.text.isEmpty){
                        Utils.flushBarErrorMessage('Veuiller entrer votre mot de passe', context);
                      }else if (_validePasswordController.text.isEmpty){
                        Utils.flushBarErrorMessage('Veuiller valider votre mot de passe', context);
                      }else if (_passwordController.text != _validePasswordController.text){
                        Utils.flushBarErrorMessage('Les mots de passe ne correspondent pas', context);
                      }else if(_passwordController.text.length < 6){
                        Utils.flushBarErrorMessage('Le mot de passe doit contenir plus de 6 caractères', context);
                      }else if(selectGender.isEmpty) {
                        Utils.flushBarErrorMessage('Veuiller selectionner votre genre', context);
                      }else{
                        bool firstTimeState = true;
                        firstTimeState = await hive.getHiveData('firstTime') ?? true;
                        print(firstTimeState);
                        auth.signupUserWithFirebase(_emailController.text, _passwordController.text, _nameController.text, selectGender).then((value){
                          firstTimeState
                              ?  Navigator.pushNamed(context, RoutesName.onboarding)
                              : Navigator.pushNamed(context, RoutesName.home);
                        });
                      }
                    },
                  ),
                  SizedBox(height: height * .04,),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, RoutesName.login);
                    },
                    child:Text('Login')
                  )
                ]),
          ),
        ));
  }
}
