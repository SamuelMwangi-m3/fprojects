import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal() {
    // Initialize from current session
    _userId = Supabase.instance.client.auth.currentUser?.id;
    // Listen to auth state changes
    Supabase.instance.client.auth.onAuthStateChange.listen((event) {
      _userId = Supabase.instance.client.auth.currentUser?.id;
      _notify?.call(_userId);
    });
  }

  String? _userId;
  void Function(String?)? _notify;

  bool get isLoggedIn => _userId != null;
  String? get userId => _userId;

  void onAuthChanged(void Function(String?) listener) {
    _notify = listener;
  }

  Future<void> signInWithEmail(String email, String password) async {
    final res = await Supabase.instance.client.auth.signInWithPassword(email: email, password: password);
    _userId = res.user?.id;
  }

  Future<void> signInWithGoogle() async {
    await Supabase.instance.client.auth.signInWithOAuth(OAuthProvider.google);
  }

  Future<void> signInWithFacebook() async {
    await Supabase.instance.client.auth.signInWithOAuth(OAuthProvider.facebook);
  }

  Future<void> continueAsGuest() async {
    _userId = 'guest';
    _notify?.call(_userId);
  }

  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
    _userId = null;
    _notify?.call(_userId);
  }
}


