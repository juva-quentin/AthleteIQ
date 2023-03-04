import 'package:athlete_iq/resources/size.dart';
import 'package:athlete_iq/ui/auth/providers/auth_view_model_provider.dart';
import 'package:athlete_iq/ui/auth/signup_screen.dart';
import 'package:athlete_iq/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/routes/root.dart';
import '../providers/loading_provider.dart';


class LoginScreen extends ConsumerWidget {
  LoginScreen({Key, key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  static const route = "/login";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = authViewModelProvider;
    final model = ref.read(authViewModelProvider);
    final AppSize appSize = AppSize(context);
    final height = appSize.globalHeight;
    final width = appSize.globalWidth;
    return Scaffold(
      resizeToAvoidBottomInset : false,
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(children: [
              Container(
                height: height * .30,
                width: width,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(bottomRight: Radius.circular(35), bottomLeft: Radius.circular(35)),
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
            SizedBox(
              height: height * .08,
            ),
            Consumer(
            builder: (context, ref, child) {
              final isLoading = ref.watch(loadingProvider);
              ref.watch(provider);
              return InkWell(
                onTap:  model.email.isNotEmpty &&
                    model.password.isNotEmpty 
                    ? () async {
                  if (_formKey.currentState!.validate()) {
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
                      color: Theme.of(context).buttonTheme.colorScheme!.primary,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                      child: isLoading.loading
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                          : Text(
                        "Connexion",
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
                        context, SignupScreen.route);
                  },
                  child: const Text(
                    "Creer un comte",
                    style: TextStyle(color: Color.fromARGB(255, 0, 152, 240)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}