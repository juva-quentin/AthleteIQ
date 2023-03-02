import 'package:athlete_iq/ui/auth/providers/auth_view_model_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/routes/root.dart';
import '../../utils/utils.dart';

class EmailVerifyPage extends ConsumerStatefulWidget {
  const EmailVerifyPage({Key? key}) : super(key: key);
  static const String route = "/verifyEmail";
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EmailVerifyPageState();
}

class _EmailVerifyPageState extends ConsumerState<EmailVerifyPage> {
  final provider = authViewModelProvider;

  void onDone(){
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, Root.route);
  }

  @override
  void initState() {
    ref.read(provider).streamCheck(onDone: onDone);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final styles = theme.textTheme;
    final model = ref.read(provider);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await model.logout();
              onDone();
            },
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            Text(
              "Veuiller vérifier votre email",
              style: styles.headlineLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              "Un email de vérification à été envoyé à ${model.user!.email!}",
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await model.reload();
                  if (model.user!.emailVerified) {
                    // ignore: use_build_context_synchronously
                    onDone();
                  } else {
                    // ignore: use_build_context_synchronously
                    Utils.flushBarErrorMessage("Votre email n'est pas vérifé", context);
                  }
                },
                child: const Text("OK"),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () async {
                  try {
                  await  model.sendEmail();
                  // ignore: use_build_context_synchronously
                  Utils.flushBarErrorMessage("Email de vérification réenvoyé", context);
                  } catch (e) {
                    if (kDebugMode) {
                      print(e);
                    }
                  }
                },
                child: const Text("Renvoyer"),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
  }

