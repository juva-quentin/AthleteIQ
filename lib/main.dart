import 'dart:convert';
import 'package:athlete_iq/app/app.dart';
import 'package:athlete_iq/ui/auth/login_screen.dart';
import 'package:athlete_iq/ui/auth/providers/auth_view_model_provider.dart';
import 'package:athlete_iq/ui/onboarding_screen.dart';
import 'package:athlete_iq/ui/parcour-detail/parcour_details_screen.dart';
import 'package:athlete_iq/ui/providers/cache_provider.dart';
import 'package:athlete_iq/utils/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:json_theme/json_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';
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
  ]).then((_) async {
    final initialLink = await getInitialLink();
    FlutterNativeSplash.remove(); // Désactiver le splash screen ici
    runApp(ProviderScope(overrides: [
      initialLinkProvider.overrideWithValue(initialLink),
    ], child: MyApp(theme: theme)));
  });
}

final initialLinkProvider = Provider<String?>((ref) => null);

class MyApp extends ConsumerWidget {
  final ThemeData theme;
  MyApp({required this.theme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseAuth = ref.watch(firebaseAuthProvider);
    final cache = ref.watch(cacheProvider.future);
    final initialLink = ref.watch(initialLinkProvider);

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AthleteIQ',
        theme: theme,
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
          future: Future.wait([cache, Future.value(initialLink)]),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              final prefs = snapshot.data![0] as SharedPreferences;
              final isLoggedIn = firebaseAuth.currentUser != null;
              final hasSeenOnboarding = prefs.getBool('seen') ?? false;
              final link = snapshot.data![1] as String?;
              if (link != null) {
                final parcourId = extractParcourIdFromLink(link);
                if (isLoggedIn && parcourId != null) {
                  return ParcourDetails(parcourId);
                }
              }
              return hasSeenOnboarding
                  ? isLoggedIn
                      ? const App()
                      : LoginScreen()
                  : const OnboardingScreen();
            }
          },
        ),
        onGenerateRoute: AppRouter.onNavigate,
      ),
    );
  }
}

String? extractParcourIdFromLink(String link) {
  Uri uri = Uri.parse(link);
  if (uri.pathSegments.length > 3 &&
      uri.pathSegments[0] == 'parcours' &&
      uri.pathSegments[1] == 'details') {
    return uri.pathSegments[2];
  }
  return null;
}
