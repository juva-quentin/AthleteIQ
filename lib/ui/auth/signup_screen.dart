import 'package:athlete_iq/ui/auth/providers/auth_view_model_provider.dart';
import 'package:athlete_iq/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gender_selection/gender_selection.dart';
import '../../resources/size.dart';
import '../providers/loading_provider.dart';
import 'email_verify_page.dart';
import 'login_screen.dart';


class SignupScreen extends ConsumerWidget {
  SignupScreen({Key? key}) : super(key: key);

  static const String route = "/register";
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = authViewModelProvider;
    final model = ref.read(provider);
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
                  color: Theme.of(context).colorScheme.primary),
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
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: model.email,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.account_circle_outlined),
                    labelText: "Pseudo",
                  ),
                  onChanged: (v) => model.pseudo = v,
                ),
                TextFormField(
                  initialValue: model.email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined),
                    labelText: "Email",
                  ),
                  onChanged: (v) => model.email = v,
                  validator: (v) => model.emailValidate(v!),
                ),
                Consumer(
                  builder: (context, ref, child) {
                    ref.watch(
                        provider.select((value) => value.obscurePassword));
                    return TextFormField(
                      obscureText: model.obscurePassword,
                      initialValue: model.password,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        labelText: "Mot de passe",
                        suffixIcon: IconButton(
                          onPressed: () {
                            model.obscurePassword = !model.obscurePassword;
                          },
                          icon: Icon(model.obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined),
                        ),
                      ),
                      onChanged: (v) => model.password = v,
                    );
                  },
                ),
                Consumer(
                  builder: (context, ref, child) {
                    ref.watch(provider
                        .select((value) => value.obscureConfirmPassword));
                    return TextFormField(
                      obscureText: model.obscureConfirmPassword,
                      initialValue: model.confirmPassord,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        labelText: "Confirmer le mot de passe",
                        suffixIcon: IconButton(
                          onPressed: () {
                            model.obscureConfirmPassword =
                            !model.obscureConfirmPassword;
                          },
                          icon: Icon(model.obscureConfirmPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined),
                        ),
                      ),
                      onChanged: (v) => model.confirmPassord = v,
                      validator: (v) =>
                      v != model.password ? "Les mot de passes ne correspondes pas" : null,
                    );
                  },
                ),
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
                        model.sex = 'Homme';
                      } else {
                        model.sex = 'Femme';
                      }
                    },
                    maleImage: const NetworkImage("https://cdn-icons-png.flaticon.com/512/18/18148.png"),
                    femaleImage: const NetworkImage("https://cdn-icons-png.flaticon.com/512/9460/9460573.png"),
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
                Consumer(
                    builder: (context, ref, child) {
                      final isLoading = ref.watch(loadingProvider);
                      ref.watch(provider);
                      return InkWell(
                        onTap: model.email.isNotEmpty &&
                            model.password.isNotEmpty &&
                            model.confirmPassord.isNotEmpty &&
                            model.sex.isNotEmpty
                            ? () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              await model.register();
                              // ignore: use_build_context_synchronously
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                EmailVerifyScreen.route,
                                    (route) => false,
                              );
                            } catch (e) {
                              Utils.flushBarErrorMessage(e.toString(), context);
                            }
                          }
                        }
                            : null,
                        child: Container(
                            height: 40,
                            width: 200,
                            decoration: BoxDecoration(
                                color: Theme.of(context).buttonTheme.colorScheme!.primary,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: isLoading.loading
                                    ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                    : Text(
                                  "Créer un compte",
                                  style: TextStyle(color: Theme.of(context).colorScheme.background),
                                ))),
                      );
                    }
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
                        Navigator.pushReplacementNamed(
                            context, LoginScreen.route);
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
          ),
        ],
      ),
    );
  }
}
