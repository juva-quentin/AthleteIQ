import 'package:athlete_iq/utils/routes/customPopupRoute.dart';
import 'package:athlete_iq/utils/routes/routes_name.dart';
import 'package:athlete_iq/view/home_screen.dart';
import 'package:athlete_iq/view/login_screen.dart';
import 'package:athlete_iq/view/onboarding_screen.dart';
import 'package:flutter/material.dart';

import '../../app.dart';
import '../../view/info_screen.dart';
import '../../view/signup_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final argu = settings.arguments;
    switch (settings.name) {
      case RoutesName.app:
        return MaterialPageRoute(
            builder: (BuildContext context) => App());
      case RoutesName.login:
        return MaterialPageRoute(
            builder: (BuildContext context) => LoginScreen());
      case RoutesName.signup:
        return MaterialPageRoute(
            builder: (BuildContext context) => SignupScreen());
      case RoutesName.onboarding:
        return MaterialPageRoute(
            builder: (BuildContext context) => OnboardingScreen());
      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
              body: Center(
            child: Text("La page n'existe pas"),
          ));
        });
    }
  }
}
