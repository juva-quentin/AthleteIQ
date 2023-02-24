import 'dart:convert';

import 'package:athlete_iq/utils/routes/routes.dart';
import 'package:athlete_iq/utils/routes/routes_name.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
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
  await Hive.initFlutter();
  runApp(ProviderScope(child: MyApp(theme: theme,)));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.theme});
  final ThemeData theme;
  @override
  Widget build(BuildContext context) {

    print(FirebaseAuth.instance.currentUser);
    FlutterNativeSplash.remove();
    return MaterialApp(
      title: 'AthleteIQ',
      debugShowCheckedModeBanner: false,
      theme: theme,
      initialRoute: FirebaseAuth.instance.currentUser != null ? RoutesName.app: RoutesName.login,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
