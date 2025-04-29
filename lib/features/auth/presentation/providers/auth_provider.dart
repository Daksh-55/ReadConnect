import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref
      .watch(supabaseClientProvider)
      .auth
      .onAuthStateChange
      .map((event) => event.session?.user);
});

final currentUserProvider = FutureProvider<User?>((ref) async {
  final user = ref.watch(supabaseClientProvider).auth.currentUser;
  if (user == null) return null;

  final response = await ref
      .watch(supabaseClientProvider)
      .from('users')
      .select()
      .eq('id', user.id)
      .single();

  return user;
});

final userRoleProvider = FutureProvider<String?>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  if (user == null) return null;

  final response = await ref
      .watch(supabaseClientProvider)
      .from('users')
      .select('role')
      .eq('id', user.id)
      .single();

  return response['role'] as String?;
});

final allUsersProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final client = ref.watch(supabaseClientProvider);
  final response = await client.from('users').select('id, email');
  if (response is List) {
    return List<Map<String, dynamic>>.from(response);
  }
  return [];
});
