import 'dart:convert';

import 'package:athlete_iq/app/app.dart';
import 'package:athlete_iq/ui/auth/login_screen.dart';
import 'package:athlete_iq/ui/auth/providers/auth_view_model_provider.dart';
import 'package:athlete_iq/ui/onboarding_screen.dart';
import 'package:athlete_iq/ui/providers/cache_provider.dart';
import 'package:athlete_iq/utils/routes/router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:json_theme/json_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final themeStr = await rootBundle.loadString('assets/appainter_theme.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) {
    runApp(ProviderScope(child: MyApp(theme: theme)));
    FlutterNativeSplash.remove();
  });
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key, required this.theme});
  final ThemeData theme;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseAuth = ref.watch(firebaseAuthProvider);
    final cache = ref.watch(cacheProvider.future);

    return MaterialApp(
      title: 'AthleteIQ',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: FutureBuilder(
        future: cache,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.white,
            );
          } else {
            final SharedPreferences prefs = snapshot.data!;
            final bool isLoggedIn = firebaseAuth.currentUser != null;

            bool hasSeenOnboarding =
                prefs.getBool('seen') ?? false;
            Widget targetScreen = hasSeenOnboarding
                ? isLoggedIn
                    ? const App()
                    : LoginScreen()
                : const OnboardingScreen();
            return targetScreen;
          }
        },
      ),
      onGenerateRoute: AppRouter.onNavigate,
    );
  }
}

