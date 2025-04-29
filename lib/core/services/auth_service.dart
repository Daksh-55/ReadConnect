import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final _supabase = Supabase.instance.client;

  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  Future<void> signIn({required String email, required String password}) async {
    await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String role,
    required String name,
  }) async {
    // First, sign up the user
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
    );

    // Try to get the user id from the response or the current session
    final userId = response.user?.id ?? _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('Failed to create user');
    }

    // Then, create the user profile in the users table
    await _supabase.from('users').insert({
      'id': userId,
      'email': email,
      'role': role,
      'name': name,
    });
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }

  Future<String?> getUserRole() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    final response =
        await _supabase.from('users').select('role').eq('id', user.id).single();

    return response['role'] as String?;
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    final response =
        await _supabase.from('users').select().eq('id', user.id).single();

    return response;
  }
}
