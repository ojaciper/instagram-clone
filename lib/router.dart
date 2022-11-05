import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/screens/sign_up_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const LoginScreen(),
      );
    case SignUpScreen.routeName:
      return MaterialPageRoute(
        builder: (_) => const SignUpScreen(),
      );

    default:
      return MaterialPageRoute(
        builder: (_) => const Center(
          child: Text("Page does not exit"),
        ),
      );
  }
}
