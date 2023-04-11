import 'dart:convert';

import 'package:athlete_iq/ui/providers/cache_provider.dart';
import 'package:athlete_iq/utils/routes/root.dart';
import 'package:athlete_iq/utils/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:json_theme/json_theme.dart';
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
  ]).then((value) => runApp(ProviderScope(child: MyApp(theme: theme))));

}

class MyApp extends ConsumerWidget {
  const MyApp({super.key, required this.theme});
  final ThemeData theme;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'AthleteIQ',
      debugShowCheckedModeBanner: false,
      theme: theme,
      initialRoute: InitRoute.route,
      onGenerateRoute: AppRouter.onNavigate,
    );
  }
}

class InitRoute extends ConsumerStatefulWidget {
  const InitRoute({Key? key}) : super(key: key);
  static const String route = "/";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InitRouteState();
}

class _InitRouteState extends ConsumerState<InitRoute> {

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    await ref.read(cacheProvider.future);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      Root.route,
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
  }
