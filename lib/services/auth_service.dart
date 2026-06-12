import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class AppSession {
  static AppUser? _currentUser;

  static AppUser? get currentUser => _currentUser;

  static void setUser(AppUser? user) => _currentUser = user;

  static String? get currentUid => _currentUser?.uid;
}

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  AppUser? get currentUser => AppSession.currentUser;

  Stream<AppUser?> get authStateChanges async* {
    final authUser = _client.auth.currentUser;
    if (authUser == null) {
      AppSession.setUser(null);
      yield null;
      return;
    }
    yield await getUserData(authUser.id);
  }

  Future<String?> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required String passengerType,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );
      final authUser = response.user;
      if (authUser == null) return 'Could not create account.';

      final appUser = AppUser(
        uid: authUser.id,
        email: email,
        fullName: fullName,
        phoneNumber: phoneNumber,
        passengerType: passengerType,
        createdAt: DateTime.now(),
      );

      await _client.from('profiles').upsert(appUser.toMap());
      AppSession.setUser(appUser);
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Registration failed. Please try again.';
    }
  }

  Future<String?> signIn(String emailOrPhone, String password) async {
    try {
      var email = emailOrPhone;
      if (!emailOrPhone.contains('@')) {
        final profile = await _client
            .from('profiles')
            .select('email')
            .eq('phone_number', emailOrPhone)
            .eq('role', 'passenger')
            .maybeSingle();
        if (profile == null) return 'No account found for that contact number.';
        email = profile['email'];
      }

      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final authUser = response.user;
      if (authUser == null) return 'Invalid login credentials.';

      final appUser = await getUserData(authUser.id);
      if (appUser == null) return 'Passenger profile was not found.';
      AppSession.setUser(appUser);
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (_) {
      return 'Login failed. Please try again.';
    }
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
    AppSession.setUser(null);
  }

  Future<AppUser?> getUserData(String uid) async {
    final row = await _client
        .from('profiles')
        .select()
        .eq('id', uid)
        .eq('role', 'passenger')
        .maybeSingle();
    if (row == null) return null;
    final user = AppUser.fromMap(row);
    AppSession.setUser(user);
    return user;
  }
}
