import 'package:athlete_iq/ui/auth/signup_screen.dart';
import 'package:athlete_iq/utils/routes/root.dart';
import 'package:flutter/material.dart';

import '../../ui/auth/email_verify_page.dart';
import '../../ui/auth/login_screen.dart';

class AppRouter {
  static Route<MaterialPageRoute> onNavigate(RouteSettings settings) {
    late final Widget selectedPage;

    switch (settings.name) {
      case LoginScreen.route:
        selectedPage = LoginScreen();
        break;
      case SignupScreen.route:
        selectedPage = SignupScreen();
        break;
      case EmailVerifyPage.route:
        selectedPage = EmailVerifyPage();
        break;
      default:
        selectedPage = const Root();
        break;
    }

    return MaterialPageRoute(builder: (context) => selectedPage);
  }
}
