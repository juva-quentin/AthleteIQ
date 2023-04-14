import 'package:athlete_iq/ui/auth/providers/auth_view_model_provider.dart';
import 'package:athlete_iq/ui/auth/signup_screen.dart';
import 'package:athlete_iq/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../utils/routes/root.dart';
import '../providers/loading_provider.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({Key? key}) : super(key: key);
  final _formLoginKey = GlobalKey<FormState>();
  static const route = "/login";
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
        body: Form(
          key: _formLoginKey,
          child: Column(
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
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                initialValue: model.email,
                autocorrect: false,
                textCapitalization: TextCapitalization.none,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined),
                  labelText: "Email",
                ),
                onChanged: (v) => model.email = v,
                validator: (v) => model.emailValidate(v!),
              ),
              TextFormField(
                obscureText: model.obscurePassword,
                keyboardType: TextInputType.visiblePassword,
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
              SizedBox(
                height: height * .08,
              ),
              InkWell(
                onTap: model.email.isNotEmpty && model.password.isNotEmpty
                    ? () async {
                        if (_formLoginKey.currentState!.validate()) {
                          try {
                            await model.login();
                            // ignore: use_build_context_synchronously
                            Navigator.pushReplacementNamed(
                              context,
                              Root.route,
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
                        color: model.email.isNotEmpty && model.password.isNotEmpty
                            ? Theme.of(context).buttonTheme.colorScheme!.primary : Theme.of(context).disabledColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: isLoading.loading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                "Connexion",
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.background),
                              ))),
              ),
              SizedBox(
                height: height * .02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Vous n'avez pas de compte ? "),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, SignupScreen.route);
                    },
                    child: const Text(
                      "Créer un compte",
                      style: TextStyle(color: Color.fromARGB(255, 0, 152, 240)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
