import 'package:athlete_iq/ui/auth/login_screen.dart';
import 'package:athlete_iq/ui/providers/loading_provider.dart';
import 'package:athlete_iq/ui/settings/settings_view_model_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

import '../../app/app.dart';
import '../../utils/utils.dart';
import '../auth/providers/auth_view_model_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  static const route = "/settings";
  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      try {
        await ref.read(settingsViewModelProvider).getUserInfo();
      } catch (e) {
        Utils.flushBarErrorMessage(e.toString(), context);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final model = ref.watch(settingsViewModelProvider);
    final authModel = ref.watch(authViewModelProvider);
    final isLoading = ref.watch(loadingProvider);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          "Paramètres",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
            icon: Icon(UniconsLine.arrow_left, size: width * .1),
            onPressed: () => Navigator.pop(context)),
        actions: [
          IconButton(
              onPressed: () async {
                try {
                  await authModel.logout();
                  FirebaseFirestore.instance.terminate();
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginScreen.route, (Route<dynamic> route) => false);
                } catch (e) {
                  Utils.flushBarErrorMessage(e.toString(), context);
                  if (kDebugMode) {
                    print(e);
                  }
                }
              },
              icon: Icon(UniconsLine.exit, size: width * .1)),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: width * .02),
        height: height * .42,
        width: double.infinity,
        child: Form(
          key: model.formSettingKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextFormField(
                controller: model.pseudoController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.account_circle_outlined),
                  labelText: "Pseudo",
                ),
                onChanged: (value) {
                  model.actu();
                },
              ),
              TextFormField(
                controller: model.emailController,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined),
                  labelText: "Email",
                ),
                onChanged: (value) {
                  model.actu();
                },
                validator: (v) => model.emailValidate(v!),
              ),
              TextFormField(
                obscureText: model.obscurePassword,
                controller: model.passwordController,
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
                onChanged: (value) {
                  model.actu();
                },
              ),
              TextFormField(
                obscureText: model.obscureConfirmPassword,
                controller: model.confirmPasswordController,
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
                validator: (v) => v != model.password
                    ? "Les mots de passe ne correspondent pas"
                    : null,
                onChanged: (value) {
                  model.actu();
                },
              ),
              SizedBox(
                height: height * .015,
              ),
              InkWell(
                onTap: model.valideForm()
                    ? () async {
                        if (model.formSettingKey.currentState!.validate()) {
                          try {
                            await model.updateUser().then((value) =>
                                Utils.toastMessage(
                                    "Votre profile à été mis  à jour"));
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
                      color: model.valideForm()
                          ? Theme.of(context).buttonTheme.colorScheme!.primary
                          : Theme.of(context).disabledColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: isLoading.loading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            "Modifier",
                            style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.background),
                          ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  if (model.formSettingKey.currentState!.validate()) {
                    try {} catch (e) {
                      Utils.flushBarErrorMessage(e.toString(), context);
                    }
                  }
                },
                child: Container(
                  height: 40,
                  width: 200,
                  decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: isLoading.loading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            "Supprimer votre compte",
                            style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.background),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
