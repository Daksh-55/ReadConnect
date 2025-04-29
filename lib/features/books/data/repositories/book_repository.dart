import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:readconnect/core/constants/supabase_constants.dart';
import 'package:readconnect/features/books/domain/models/book_model.dart';
import 'package:readconnect/features/auth/presentation/providers/auth_provider.dart';

final bookRepositoryProvider = Provider<BookRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return BookRepository(supabase);
});

class BookRepository {
  final SupabaseClient _supabase;

  BookRepository(this._supabase);

  Future<List<Book>> getAllBooks() async {
    try {
      final response = await _supabase
          .from(SupabaseConstants.booksTable)
          .select('*, users:owner_id(name)');
      return response.map((json) => Book.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch books: $e');
    }
  }

  Future<Book> getBookById(String id) async {
    try {
      final response = await _supabase
          .from(SupabaseConstants.booksTable)
          .select('*, users:owner_id(name)')
          .eq('id', id)
          .single();
      return Book.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch book: $e');
    }
  }

  Future<List<Book>> searchBooks(String query) async {
    try {
      final response = await _supabase
          .from(SupabaseConstants.booksTable)
          .select()
          .ilike('title', '%$query%');
      return response.map((json) => Book.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to search books: $e');
    }
  }

  Future<void> addBook(Book book) async {
    try {
      await _supabase.from(SupabaseConstants.booksTable).insert(book.toJson());
    } catch (e) {
      throw Exception('Failed to add book: $e');
    }
  }

  Future<void> updateBook(Book book) async {
    try {
      await _supabase
          .from(SupabaseConstants.booksTable)
          .update(book.toJson())
          .eq('id', book.id);
    } catch (e) {
      throw Exception('Failed to update book: $e');
    }
  }

  Future<void> deleteBook(String bookId) async {
    try {
      await _supabase
          .from(SupabaseConstants.booksTable)
          .delete()
          .eq('id', bookId);
    } catch (e) {
      throw Exception('Failed to delete book: $e');
    }
  }

  Future<void> updateBookAvailability(String id, int availableCopies) async {
    try {
      await _supabase
          .from(SupabaseConstants.booksTable)
          .update({'available_copies': availableCopies}).eq('id', id);
    } catch (e) {
      throw Exception('Failed to update book availability: $e');
    }
  }

  Future<List<Book>> getFavoriteBooks(String userId) async {
    try {
      final response = await _supabase
          .from(SupabaseConstants.favoritesTable)
          .select('book_id')
          .eq('user_id', userId);

      if (response.isEmpty) {
        throw Exception('No favorite books found');
      }

      final bookIds = response.map((r) => r['book_id'] as String).toList();
      final booksResponse = await _supabase
          .from(SupabaseConstants.booksTable)
          .select()
          .inFilter('id', bookIds);

      return booksResponse.map((json) => Book.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch favorite books: $e');
    }
  }
}
