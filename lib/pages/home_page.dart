import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../routers/router.dart';

/// ホーム画面。
///
/// ログイン後に遷移する主要な画面。
class HomePage extends StatelessWidget {
  HomePage({super.key});

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ホーム')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await _authService.signOut();
            goRouter.go(loginPath);
          },
          child: const Text('ログアウト'),
        ),
      ),
    );
  }
}
