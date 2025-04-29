import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:readconnect/core/constants/supabase_constants.dart';
import 'package:readconnect/features/requests/domain/models/request_model.dart';
import 'package:readconnect/features/auth/presentation/providers/auth_provider.dart';

final requestRepositoryProvider = Provider<RequestRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return RequestRepository(supabase);
});

class RequestRepository {
  final SupabaseClient _supabase;

  RequestRepository(this._supabase);

  Future<List<BookRequest>> getRequestsByUserId(String userId) async {
    try {
      final response = await _supabase
          .from(SupabaseConstants.requestsTable)
          .select('*, users!requests_user_id_fkey(name)')
          .eq('user_id', userId)
          .order('request_date', ascending: false);
      return response.map((json) => BookRequest.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch user requests: $e');
    }
  }

  Future<List<BookRequest>> getPendingRequests() async {
    try {
      final response = await _supabase
          .from(SupabaseConstants.requestsTable)
          .select('*, users!requests_user_id_fkey(name)')
          .eq('status', 'pending')
          .order('request_date', ascending: true);
      return response.map((json) => BookRequest.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch pending requests: $e');
    }
  }

  Future<void> createRequest(BookRequest request) async {
    try {
      await _supabase
          .from(SupabaseConstants.requestsTable)
          .insert(request.toJson());
    } catch (e) {
      throw Exception('Failed to create request: $e');
    }
  }

  Future<void> updateRequestStatus(
    String requestId,
    String status,
    String librarianId,
  ) async {
    try {
      await _supabase.from(SupabaseConstants.requestsTable).update({
        'status': status,
        'librarian_id': librarianId,
        'approval_date': DateTime.now().toIso8601String(),
      }).eq('id', requestId);
    } catch (e) {
      throw Exception('Failed to update request status: $e');
    }
  }

  Future<void> markAsReturned(String requestId) async {
    try {
      await _supabase.from(SupabaseConstants.requestsTable).update({
        'status': 'returned',
        'return_date': DateTime.now().toIso8601String(),
      }).eq('id', requestId);
    } catch (e) {
      throw Exception('Failed to mark request as returned: $e');
    }
  }

  Future<BookRequest> getRequestById(String id) async {
    try {
      final response = await _supabase
          .from(SupabaseConstants.requestsTable)
          .select('*, users!requests_user_id_fkey(name)')
          .eq('id', id)
          .single();
      return BookRequest.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch request: $e');
    }
  }

  Future<List<BookRequest>> getAllRequests() async {
    try {
      final response = await _supabase
          .from(SupabaseConstants.requestsTable)
          .select('*, users!requests_user_id_fkey(name)')
          .order('request_date', ascending: false);
      print('Supabase getAllRequests response:');
      print(response);
      if (response.isNotEmpty) {
        print('First response users field: \\${response[0]['users']}');
      }
      return response.map((json) => BookRequest.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch all requests: $e');
    }
  }

  Future<List<BookRequest>> getRequestsForLibrarian(String librarianId) async {
    try {
      final response = await _supabase
          .from(SupabaseConstants.requestsTable)
          .select('*, books!inner(*), users!requests_user_id_fkey(name)')
          .eq('books.owner_id', librarianId)
          .order('request_date', ascending: false);
      return response.map((json) => BookRequest.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch librarian requests: $e');
    }
  }

  Future<bool> addRequestWithLibrarian(String bookId, String userId) async {
    try {
      // Fetch the book to get its owner_id
      final book =
          await _supabase.from('books').select().eq('id', bookId).single();
      final librarianId = book['owner_id'];
      final now = DateTime.now().toUtc();
      await _supabase.from(SupabaseConstants.requestsTable).insert({
        'user_id': userId,
        'book_id': bookId,
        'librarian_id': librarianId,
        'status': 'pending',
        'request_date': now.toIso8601String(),
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      });
      return true;
    } catch (e) {
      print('Add request exception: $e');
      return false;
    }
  }

  Future<bool> approveRequest(String requestId, {String? bookId}) async {
    try {
      final now = DateTime.now().toUtc();
      final returnDate = now.add(const Duration(days: 7));
      await _supabase.from(SupabaseConstants.requestsTable).update({
        'status': 'approved',
        'approval_date': now.toIso8601String(),
        'return_date': returnDate.toIso8601String(),
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
