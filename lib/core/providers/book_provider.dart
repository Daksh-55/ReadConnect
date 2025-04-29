import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final bookProvider =
    StateNotifierProvider<BookNotifier, AsyncValue<void>>((ref) {
  return BookNotifier();
});

class BookNotifier extends StateNotifier<AsyncValue<void>> {
  BookNotifier() : super(const AsyncValue.data(null));

  Future<void> addBook({
    required String title,
    required String author,
    String? description,
    required String category,
    required int totalCopies,
    String? libraryName,
  }) async {
    state = const AsyncValue.loading();
    final supabase = Supabase.instance.client;
    final now = DateTime.now().toUtc();
    final userId = supabase.auth.currentUser?.id;
    final response = await supabase.from('books').insert({
      'title': title,
      'author': author,
      'description': description ?? '',
      'category': category,
      'total_copies': totalCopies,
      'available_copies': totalCopies,
      'published_date': now.toIso8601String().substring(0, 10),
      'created_at': now.toIso8601String(),
      'updated_at': now.toIso8601String(),
      'owner_id': userId,
      'library_name': libraryName ?? '',
    });
    if (response.error != null) {
      state = AsyncValue.error(response.error!.message, StackTrace.current);
    } else {
      state = const AsyncValue.data(null);
    }
  }
}
