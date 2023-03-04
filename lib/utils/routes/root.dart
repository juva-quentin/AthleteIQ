import 'package:athlete_iq/ui/auth/login_screen.dart';
import 'package:athlete_iq/ui/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../app/app.dart';
import '../../ui/auth/providers/auth_view_model_provider.dart';
import '../../ui/providers/cache_provider.dart';

class Root extends ConsumerWidget {
  const Root({Key? key}) : super(key: key);
  static const String route = "/root";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seen =
        ref.read(cacheProvider).value?.getBool("seen") ?? false;
    final auth = ref.read(authViewModelProvider);
    print("seen $seen");
    print("auth $auth");
    return !seen
        ? const OnboardingScreen()
        : auth.user != null
            ? const App()
            : LoginScreen();
  }
}