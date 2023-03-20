import 'package:athlete_iq/main.dart';
import 'package:athlete_iq/ui/auth/signup_screen.dart';
import 'package:athlete_iq/ui/chat/homeChat_screen.dart';
import 'package:athlete_iq/ui/chat/search_page.dart';
import 'package:athlete_iq/utils/routes/root.dart';
import 'package:flutter/material.dart';

import '../../ui/auth/email_verify_page.dart';
import '../../ui/auth/login_screen.dart';
import '../../ui/settings_screen.dart';


class AppRouter {
  static Route<MaterialPageRoute> onNavigate(RouteSettings settings) {
    late final Widget selectedPage;
    switch (settings.name) {
      case InitRoute.route:
        selectedPage = InitRoute();
        break;
      case LoginScreen.route:
        selectedPage = LoginScreen();
        break;
      case SignupScreen.route:
        selectedPage = SignupScreen();
        break;
      case EmailVerifyScreen.route:
        selectedPage = EmailVerifyScreen();
        break;
      case SettingsScreen.route:
        selectedPage = SettingsScreen();
        break;
      case HomeChatScreen.route:
        selectedPage = HomeChatScreen();
        break;
      case SearchPage.route:
        selectedPage = SearchPage();
        break;
      default:
        selectedPage = const Root();
        break;
    }

    return MaterialPageRoute(builder: (context) => selectedPage);
  }
}
