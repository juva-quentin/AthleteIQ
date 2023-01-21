import 'package:athlete_iq/utils/routes/routes_name.dart';
import 'package:athlete_iq/view/home_screen.dart';
import 'package:athlete_iq/view/login_screen.dart';
import 'package:flutter/material.dart';

import '../../view/signup_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final argu = settings.arguments;
    switch (settings.name) {
      case RoutesName.home:
        return MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen());
      case RoutesName.login:
        return MaterialPageRoute(
            builder: (BuildContext context) => LoginScreen());
      case RoutesName.signup:
        return MaterialPageRoute(
            builder: (BuildContext context) => SignupScreen());
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
