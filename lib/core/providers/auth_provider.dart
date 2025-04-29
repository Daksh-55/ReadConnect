import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges.map((event) => event.session?.user);
});

final userRoleProvider = FutureProvider<String?>((ref) async {
  final authService = ref.watch(authServiceProvider);
  return await authService.getUserRole();
});

final userProfileProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final authService = ref.watch(authServiceProvider);
  return await authService.getUserProfile();
});

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthController(authService);
});

class AuthController extends StateNotifier<AsyncValue<void>> {
  final AuthService _authService;

  AuthController(this._authService) : super(const AsyncValue.data(null));

  Future<AsyncValue<void>> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
        () => _authService.signIn(email: email, password: password));
    return state;
  }

  Future<AsyncValue<void>> signUp(String email, String password, String role,
      {required String name}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _authService.signUp(
        email: email, password: password, role: role, name: name));
    return state;
  }

  Future<AsyncValue<void>> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _authService.signOut());
    return state;
  }

  Future<AsyncValue<void>> resetPassword(String email) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _authService.resetPassword(email));
    return state;
  }
}
