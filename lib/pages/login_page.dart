import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../routers/router.dart';
import '../services/auth_service.dart';

/// メールアドレスの形式を確認する正規表現
final RegExp _emailRegExp = RegExp(
  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
);

/// ログイン画面。
///
/// この画面でユーザーは自分のメールアドレスとパスワードを使用してログインする。
class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  LoginPage({super.key});

  /// ログインする。
  Future<void> _signIn(
    ScaffoldMessengerState scaffoldMessenger,
    BuildContext context,
  ) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (!_validateFields(email, password, scaffoldMessenger)) {
      return;
    }

    try {
      final errorMsg = await _authService.signInWithEmailAndPassword(
        email,
        password,
      );
      if (errorMsg == null) {
        goRouter.go(homePath);
      } else {
        _showErrorSnackBar(scaffoldMessenger, errorMsg);
      }
    } on FirebaseAuthException catch (e) {
      _showErrorSnackBar(scaffoldMessenger, e.message ?? 'エラーが発生しました。');
    }
  }

  void _showErrorSnackBar(
      ScaffoldMessengerState scaffoldMessenger, String message) {
    scaffoldMessenger.showSnackBar(SnackBar(content: Text(message)));
  }

  bool _validateFields(
      String email, String password, ScaffoldMessengerState scaffoldMessenger) {
    if (email.isEmpty || password.isEmpty) {
      _showErrorSnackBar(scaffoldMessenger, 'すべてのフィールドを入力してください。');
      return false;
    }

    if (!_emailRegExp.hasMatch(email)) {
      _showErrorSnackBar(scaffoldMessenger, '有効なメールアドレスを入力してください。');
      return false;
    }

    if (password.length < 6) {
      _showErrorSnackBar(scaffoldMessenger, 'パスワードは6文字以上である必要があります。');
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ログイン')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'メールアドレス'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'パスワード'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () {
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                _signIn(scaffoldMessenger, context);
              },
              child: const Text('ログイン'),
            ),
            TextButton(
              onPressed: () => goRouter.go(signupPath),
              child: const Text('新規登録'),
            ),
          ],
        ),
      ),
    );
  }
}
