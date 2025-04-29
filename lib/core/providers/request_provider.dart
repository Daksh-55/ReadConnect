import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:readconnect/features/requests/data/repositories/request_repository.dart';

final requestProvider = Provider<RequestService>((ref) => RequestService());

class RequestService {
  final _supabase = Supabase.instance.client;

  Future<bool> addRequest(String bookId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return false;
    try {
      // Check for existing pending request
      final existing = await _supabase.from('requests').select().match({
        'user_id': userId,
        'book_id': bookId,
        'status': 'pending',
      });
      if (existing is List && existing.isNotEmpty) {
        print('Duplicate request: already exists');
        return false;
      }
      // Use the new method to set librarian_id
      final repo = RequestRepository(_supabase);
      return await repo.addRequestWithLibrarian(bookId, userId);
    } catch (e) {
      print('Add request exception: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getAllRequests() async {
    final response = await _supabase.from('requests').select();
    if (response is List) {
      return List<Map<String, dynamic>>.from(response);
    }
    return [];
  }

  Future<bool> approveRequest(String requestId, {String? bookId}) async {
    try {
      final now = DateTime.now().toUtc();
      await _supabase.from('requests').update({
        'status': 'approved',
        'approval_date': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      }).eq('id', requestId);
      // Decrease availableCopies if bookId is provided
      if (bookId != null) {
        final book =
            await _supabase.from('books').select().eq('id', bookId).single();
        final currentAvailable = (book['available_copies'] as int?) ?? 0;
        final newAvailable = currentAvailable > 0 ? currentAvailable - 1 : 0;
        await _supabase.from('books').update({
          'available_copies': newAvailable,
          'updated_at': now.toIso8601String()
        }).eq('id', bookId);
      }
      return true;
    } catch (e) {
      print('Approve request exception: $e');
      return false;
    }
  }
}
