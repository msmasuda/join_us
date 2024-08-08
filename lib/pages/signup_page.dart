import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../routers/router.dart';

/// メールアドレスの形式を確認する正規表現
final RegExp _emailRegExp = RegExp(
  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
);

/// 新規登録画面。
///
/// この画面でユーザーは新しいアカウントを作成する。
class SignupPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  final AuthService _authService = AuthService();

  SignupPage({super.key});

  /// 新規ユーザーを作成する。
  ///
  /// ユーザーが入力したメールアドレスとパスワードを使用してFirebaseで新しいアカウントを作成する。
  Future<void> _signup(
    ScaffoldMessengerState scaffoldMessenger,
    BuildContext context,
  ) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final passwordConfirm = _passwordConfirmController.text;

    if (!_validateFields(email, password, passwordConfirm, scaffoldMessenger)) {
      return;
    }

    try {
      final errorMsg = await _authService.createUserWithEmailAndPassword(
        email,
        password,
      );
      if (errorMsg == null) {
        goRouter.go(homePath);
      } else {
        scaffoldMessenger.showSnackBar(SnackBar(content: Text(errorMsg)));
        return;
      }
    } on FirebaseAuthException catch (e) {
      scaffoldMessenger
          .showSnackBar(SnackBar(content: Text(e.message ?? 'エラーが発生しました。')));
    }
  }

  void _showErrorSnackBar(
    ScaffoldMessengerState scaffoldMessenger,
    String message,
  ) {
    scaffoldMessenger.showSnackBar(SnackBar(content: Text(message)));
  }

  bool _validateFields(
    String email,
    String password,
    String passwordConfirm,
    ScaffoldMessengerState scaffoldMessenger,
  ) {
    if (email.isEmpty || password.isEmpty || passwordConfirm.isEmpty) {
      _showErrorSnackBar(scaffoldMessenger, 'すべてのフィールドを入力してください。');
      return false;
    }

    if (!_emailRegExp.hasMatch(email)) {
      _showErrorSnackBar(scaffoldMessenger, '有効なメールアドレスを入力してください。');
      return false;
    }

    if (password.length < 6) {
      _showErrorSnackBar(scaffoldMessenger, 'パスワードは6文字以上でなければなりません。');
      return false;
    }

    if (password != passwordConfirm) {
      _showErrorSnackBar(scaffoldMessenger, 'パスワードが一致しません');
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('新規登録')),
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
            TextField(
              controller: _passwordConfirmController,
              decoration: const InputDecoration(labelText: 'パスワード確認'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () {
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                _signup(scaffoldMessenger, context);
              },
              child: const Text('新規登録'),
            ),
            TextButton(
              onPressed: () => goRouter.go(loginPath),
              child: const Text('ログイン'),
            ),
          ],
        ),
      ),
    );
  }
}
