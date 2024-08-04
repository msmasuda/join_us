import 'package:firebase_auth/firebase_auth.dart';

/// Firebase Authenticationを使ってユーザーの認証操作を提供するクラス。
class AuthService {
  final FirebaseAuth _auth;

  /// コンストラクタ。
  ///
  /// FirebaseAuthのインスタンスを注入できる。デフォルトはFirebaseAuth.instance。
  ///
  /// [firebaseAuth]はFirebaseAuthのインスタンス。
  AuthService({FirebaseAuth? firebaseAuth})
      : _auth = firebaseAuth ?? FirebaseAuth.instance;

  /// 認証状態の変更を監視するStreamを提供する。
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// 新規ユーザーを作成して認証する。
  ///
  /// [emailAddress]はメールアドレス、
  /// [password]はパスワード。
  ///
  /// エラーメッセージを返す場合がある。
  Future<String?> createUserWithEmailAndPassword(
    String emailAddress,
    String password,
  ) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return _getErrorMessageFromCode(e.code);
    }
  }

  /// メールアドレスとパスワードでログインする。
  ///
  /// [emailAddress]はメールアドレス、
  /// [password]はパスワード。
  ///
  /// エラーメッセージを返す場合がある。
  Future<String?> signInWithEmailAndPassword(
    String emailAddress,
    String password,
  ) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return _getErrorMessageFromCode(e.code);
    }
  }

  /// ユーザーをログアウトする。
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Firebaseエラーコードをもとにエラーメッセージを生成する。
  ///
  /// [errorCode]はFirebaseから返されるエラーコード。
  ///
  /// 生成されたエラーメッセージを返す。
  String _getErrorMessageFromCode(String errorCode) {
    const errorMessages = {
      'invalid-email': 'メールアドレスの形式が正しくありません。',
      'user-not-found': 'このメールアドレスに該当するユーザーが見つかりません。',
      'wrong-password': 'パスワードが間違っています。',
      'too-many-requests': '多数のログイン失敗があったため、このアカウントへのアクセスは一時的に無効化されています。'
          'パスワードをリセットすることで直ちに復元できます、または後で再試行してください。',
      'weak-password': 'パスワードは最低6文字以上である必要があります。',
      'email-already-in-use': 'このメールアドレスは既に使用されています。',
      'unknown': 'エラーが発生しました。もう一度お試しください。',
    };

    return errorMessages[errorCode] ?? 'エラーが発生しました。もう一度お試しください。';
  }
}
