import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readconnect/features/requests/data/repositories/request_repository.dart';
import 'package:readconnect/features/books/data/repositories/book_repository.dart';
import 'package:readconnect/features/requests/presentation/widgets/request_card.dart';
import 'package:readconnect/core/providers/app_providers.dart';
import 'package:readconnect/features/auth/presentation/providers/auth_provider.dart';
import 'package:readconnect/features/requests/domain/models/request_model.dart';
import '../../core/providers/request_provider.dart';
import 'package:readconnect/features/books/domain/models/book_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RequestsScreen extends ConsumerWidget {
  const RequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(librarianRequestsProvider);
    final booksAsync = ref.watch(booksProvider);
    final usersAsync = ref.watch(allUsersProvider);

    print('RequestsScreen: building');
    print(
        'requestsAsync: ${requestsAsync is AsyncData ? 'data' : requestsAsync is AsyncLoading ? 'loading' : 'error'}');
    print(
        'booksAsync: ${booksAsync is AsyncData ? 'data' : booksAsync is AsyncLoading ? 'loading' : 'error'}');
    print(
        'usersAsync: ${usersAsync is AsyncData ? 'data' : usersAsync is AsyncLoading ? 'loading' : 'error'}');

    return Scaffold(
      appBar: AppBar(title: const Text('Book Requests')),
      body: requestsAsync.when(
        data: (requests) {
          if (requests.isEmpty) {
            return const Center(child: Text('No requests found.'));
          }
          return booksAsync.when(
            data: (books) => usersAsync.when(
              data: (users) {
                return ListView.builder(
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final req = requests[index];
                    final book = books.firstWhere(
                      (b) => b.id == req.bookId,
                      orElse: () => Book(
                        id: '',
                        title: 'Unknown Book',
                        author: '',
                        description: '',
                        totalCopies: 0,
                        availableCopies: 0,
                        category: '',
                        publishedDate: DateTime.now(),
                        isbn: '',
                      ),
                    );

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.08),
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(12),
                              child: const Icon(Icons.menu_book_rounded,
                                  size: 32, color: Colors.blue),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    book.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Requested by: ${req.requesterName ?? "Unknown"}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 4),
                                  _StatusChip(status: req.status),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Requested: ${req.requestDate.day}/${req.requestDate.month}/${req.requestDate.year}',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  if (req.approvalDate != null) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      'Approved: ${req.approvalDate!.day}/${req.approvalDate!.month}/${req.approvalDate!.year}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(color: Colors.green),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Return by: '
                                      '${req.approvalDate!.add(const Duration(days: 7)).day}/'
                                      '${req.approvalDate!.add(const Duration(days: 7)).month}/'
                                      '${req.approvalDate!.add(const Duration(days: 7)).year}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(color: Colors.red),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            if (req.status == 'pending')
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, top: 8.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () async {
                                    final success = await ref
                                        .read(requestProvider)
                                        .approveRequest(req.id,
                                            bookId: req.bookId);
                                    if (success && context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text('Request approved!'),
                                            backgroundColor: Colors.green),
                                      );
                                      ref.invalidate(librarianRequestsProvider);
                                      ref.invalidate(booksProvider);
                                    }
                                  },
                                  child: const Text('Approve'),
                                ),
                              ),
                            if (req.status == 'approved')
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, top: 8.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white),
                                  onPressed: () async {
                                    await ref
                                        .read(requestRepositoryProvider)
                                        .markAsReturned(req.id);
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Book marked as returned!'),
                                            backgroundColor: Colors.red),
                                      );
                                      ref.invalidate(librarianRequestsProvider);
                                      ref.invalidate(booksProvider);
                                    }
                                  },
                                  child: const Text('Return'),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: Text('Loading users...')),
              error: (e, _) => Center(child: Text('Error loading users: $e')),
            ),
            loading: () => const Center(child: Text('Loading books...')),
            error: (e, _) => Center(child: Text('Error loading books: $e')),
          );
        },
        loading: () => const Center(child: Text('Loading requests...')),
        error: (e, _) => Center(child: Text('Error loading requests: $e')),
      ),
    );
  }

  Future<void> _handleRequest(
    BuildContext context,
    WidgetRef ref,
    BookRequest request,
    String status,
  ) async {
    try {
      final user = ref.read(currentUserProvider).value;
      if (user == null) return;

      await ref
          .read(requestRepositoryProvider)
          .updateRequestStatus(request.id, status, user.id);

      if (status == 'approved') {
        final book =
            await ref.read(bookRepositoryProvider).getBookById(request.bookId);
        await ref
            .read(bookRepositoryProvider)
            .updateBookAvailability(book.id, book.availableCopies - 1);
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Request ${status == 'approved' ? 'approved' : 'rejected'} successfully',
            ),
          ),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      }
    }
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  Color get color {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'returned':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(status[0].toUpperCase() + status.substring(1)),
      backgroundColor: color.withOpacity(0.15),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
    );
  }
}
