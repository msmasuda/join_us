import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../pages/home_page.dart';
import '../pages/login_page.dart';
import '../pages/signup_page.dart';

const String homePath = '/';
const String loginPath = '/login';
const String signupPath = '/signup';

final GoRouter goRouter = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: homePath,
      builder: (BuildContext context, GoRouterState state) {
        User? user = Provider.of<User?>(context);
        if (user == null) {
          return LoginPage();
        } else {
          return HomePage();
        }
      },
    ),
    GoRoute(
      path: loginPath,
      builder: (BuildContext context, GoRouterState state) {
        return LoginPage();
      },
    ),
    GoRoute(
      path: signupPath,
      builder: (BuildContext context, GoRouterState state) {
        return SignupPage();
      },
    ),
  ],
);
