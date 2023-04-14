import 'package:athlete_iq/ui/auth/providers/auth_view_model_provider.dart';
import 'package:athlete_iq/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/loading_provider.dart';
import 'components/custom_radio.dart';
import 'email_verify_page.dart';
import 'login_screen.dart';

class SignupScreen extends ConsumerWidget {
  SignupScreen({Key? key}) : super(key: key);
  static const String route = "/register";

  final _formRegisterKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(authViewModelProvider);
    final isLoading = ref.watch(loadingProvider);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(children: [
              Container(
                height: height * .30,
                width: width,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(35),
                        bottomLeft: Radius.circular(35)),
                    color: Theme.of(context).colorScheme.primary),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: (width * .05), bottom: (width * .06)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("assets/images/logo.png",
                          height: height * .15),
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
                            color: Color.fromARGB(255, 43, 133, 222),
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
              key: _formRegisterKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: model.pseudo,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.account_circle_outlined),
                      labelText: "Pseudo",
                    ),
                    onChanged: (v) => model.pseudo = v,
                  ),
                  TextFormField(
                    autocorrect: false,
                    initialValue: model.email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined),
                      labelText: "Email",
                    ),
                    onChanged: (v) => model.email = v,
                    validator: (v) => model.emailValidate(v!),
                  ),
                  TextFormField(
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
                  ),
                  TextFormField(
                    obscureText: model.obscureConfirmPassword,
                    initialValue: model.confirmPassword,
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
                    onChanged: (v) => model.confirmPassword = v,
                    validator: (v) => v != model.password
                        ? "Les mots de passe ne correspondent pas"
                        : null,
                  ),
                  SizedBox(
                    height: height * .01,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: height *.02),
                    height: height * .1,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: model.genders.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: width*.05),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(15),
                              onTap: () {
                                for (var gender in model.genders) {
                                  gender.isSelected = false;
                                }
                                model.genders[index].isSelected = true;
                                model.changeSex(model.genders[index]);
                              },
                              child:CustomRadio(model.genders[index]),
                            ),
                          );
                        }),
                  ),
                  SizedBox(
                    height: height * .015,
                  ),
                  InkWell(
                    onTap: model.email.isNotEmpty &&
                            model.password.isNotEmpty &&
                            model.confirmPassword.isNotEmpty &&
                            model.sex.isNotEmpty
                        ? () async {
                            if (_formRegisterKey.currentState!.validate()) {
                              try {
                                await model.register();
                                // ignore: use_build_context_synchronously
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  EmailVerifyScreen.route,
                                  (route) => false,
                                );
                              } catch (e) {
                                Utils.flushBarErrorMessage(
                                    e.toString(), context);
                              }
                            }
                          }
                        : null,
                    child: Container(
                        height: 40,
                        width: 200,
                        decoration: BoxDecoration(
                            color: model.email.isNotEmpty &&
                                    model.password.isNotEmpty &&
                                    model.confirmPassword.isNotEmpty &&
                                    model.sex.isNotEmpty
                                ? Theme.of(context)
                                    .buttonTheme
                                    .colorScheme!
                                    .primary
                                : Theme.of(context).disabledColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: isLoading.loading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    "Créer un compte",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background),
                                  ))),
                  ),
                  SizedBox(
                    height: height * .02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Vous avez un compte ? "),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, LoginScreen.route);
                        },
                        child: const Text(
                          "Connexion",
                          style: TextStyle(
                              color: Color.fromARGB(255, 0, 152, 240)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
