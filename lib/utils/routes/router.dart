import 'package:athlete_iq/main.dart';
import 'package:athlete_iq/ui/auth/forgot_password_screen.dart';
import 'package:athlete_iq/ui/auth/signup_screen.dart';
import 'package:athlete_iq/ui/community/chat-page/chat_page.dart';
import 'package:athlete_iq/ui/community/chat-page/components/group_info.dart';
import 'package:athlete_iq/ui/community/homeChat_screen.dart';
import 'package:athlete_iq/ui/community/search-screen/search_page.dart';
import 'package:athlete_iq/ui/parcour-detail/parcour_details_screen.dart';
import 'package:flutter/material.dart';

import '../../app/app.dart';
import '../../ui/auth/email_verify_page.dart';
import '../../ui/auth/login_screen.dart';
import '../../ui/settings/settings_screen.dart';


class AppRouter {
  static Route<MaterialPageRoute> onNavigate(RouteSettings settings) {
    final args = settings.arguments;
    late final Widget selectedPage;
    switch (settings.name) {
      case LoginScreen.route:
        selectedPage = LoginScreen();
        break;
      case SignupScreen.route:
        selectedPage = SignupScreen();
        break;
      case ForgotPasswordScreen.route:
        selectedPage = ForgotPasswordScreen();
        break;
      case EmailVerifyScreen.route:
        selectedPage = const EmailVerifyScreen();
        break;
      case SettingsScreen.route:
        selectedPage = const SettingsScreen();
        break;
      case App.route:
        selectedPage = const App();
        break;
      case HomeChatScreen.route:
        selectedPage = const HomeChatScreen();
        break;
      case SearchPage.route:
        selectedPage = const SearchPage();
        break;
      case ChatPage.route:
        selectedPage = ChatPage(args!);
        break;
      case GroupInfo.route:
        selectedPage = GroupInfo(args!);
        break;
      case ParcourDetails.route:
        selectedPage = ParcourDetails(args!);
        break;
      default:
        selectedPage = const App();
        break;
    }

    return MaterialPageRoute(builder: (context) => selectedPage);
  }
}
