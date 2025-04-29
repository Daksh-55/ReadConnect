import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:readconnect/features/books/data/repositories/book_repository.dart';
import 'package:readconnect/features/requests/data/repositories/request_repository.dart';
import 'package:readconnect/features/auth/presentation/providers/auth_provider.dart';
import 'package:readconnect/features/books/domain/models/book_model.dart';
import 'package:readconnect/features/requests/domain/models/request_model.dart';
import 'package:readconnect/core/providers/request_provider.dart';

// Books Providers
final booksProvider = FutureProvider((ref) async {
  return ref.watch(bookRepositoryProvider).getAllBooks();
});

final searchBooksProvider = FutureProvider.family<List<Book>, String>((
  ref,
  query,
) async {
  if (query.isEmpty) return [];
  return ref.watch(bookRepositoryProvider).searchBooks(query);
});

// Requests Providers
final pendingRequestsProvider = FutureProvider((ref) async {
  return ref.watch(requestRepositoryProvider).getPendingRequests();
});

final userRequestsProvider = FutureProvider((ref) async {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return [];
  return ref.watch(requestRepositoryProvider).getRequestsByUserId(user.id);
});

// Book Request Provider
final bookRequestProvider = FutureProvider.family<BookRequest?, String>((
  ref,
  bookId,
) async {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return null;

  final requests =
      await ref.watch(requestRepositoryProvider).getRequestsByUserId(user.id);
  return requests.firstWhere(
    (request) => request.bookId == bookId && request.status == 'pending',
    orElse: () => BookRequest(
      id: '',
      userId: user.id,
      bookId: bookId,
      status: 'pending',
      requestDate: DateTime.now(),
    ),
  );
});

final allRequestsProvider = FutureProvider(
    (ref) => ref.watch(requestRepositoryProvider).getAllRequests());

final librarianRequestsProvider = FutureProvider((ref) async {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return [];
  return ref.watch(requestRepositoryProvider).getRequestsForLibrarian(user.id);
});
