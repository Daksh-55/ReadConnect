import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readconnect/core/providers/app_providers.dart';
import 'package:readconnect/features/books/domain/models/book_model.dart';
import 'package:readconnect/features/requests/domain/models/request_model.dart';

class ReaderRequestsScreen extends ConsumerWidget {
  const ReaderRequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(userRequestsProvider);
    final booksAsync = ref.watch(booksProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Book Requests')),
      body: requestsAsync.when(
        data: (requests) {
          if (requests.isEmpty) {
            return const Center(child: Text('No requests found.'));
          }
          return booksAsync.when(
            data: (books) {
              return ListView.builder(
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  final BookRequest req = requests[index];
                  final Book? book = books.firstWhere(
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
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                            child: Icon(
                              Icons.menu_book_rounded,
                              color: Colors.blue,
                              size: 40,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  book?.title ?? 'Unknown Book',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                _StatusChip(status: req.status),
                                const SizedBox(height: 4),
                                Text(
                                  'Requested: ${req.requestDate.day}/${req.requestDate.month}/${req.requestDate.year}',
                                  style: Theme.of(context).textTheme.bodySmall,
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
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error loading books: $e')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error loading requests: $e')),
      ),
    );
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
