import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:readconnect/features/books/domain/models/book_model.dart';
import 'package:readconnect/features/books/data/repositories/book_repository.dart';
import '../../../../core/providers/request_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:readconnect/core/providers/app_providers.dart';
import 'package:readconnect/screens/librarian/edit_book_screen.dart';

class BookDetailScreen extends ConsumerWidget {
  final Book book;
  final bool isLibrarian;

  const BookDetailScreen(
      {super.key, required this.book, this.isLibrarian = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Center(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.08),
                  ),
                  padding: const EdgeInsets.all(40),
                  child: Icon(
                    Icons.menu_book_rounded,
                    size: 120,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(top: 0),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 12,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          color: Colors.black87,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'by ${book.author}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.person_outline, size: 18, color: Colors.blue),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Library: \\${book.libraryName ?? "Unknown Library"}',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        color: Colors.blue,
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${book.availableCopies} of ${book.totalCopies} copies available',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontSize: 16, color: Colors.black87),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Divider(thickness: 1.2, color: Colors.grey[300]),
                  const SizedBox(height: 18),
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    book.description,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 28),
                  Divider(thickness: 1.2, color: Colors.grey[300]),
                  const SizedBox(height: 18),
                  Text(
                    'Details',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  _DetailRow(
                    icon: Icons.category_outlined,
                    label: 'Category',
                    value: book.category,
                  ),
                  _DetailRow(
                    icon: Icons.calendar_today_outlined,
                    label: 'Published',
                    value: book.publishedDate.year.toString(),
                  ),
                  _DetailRow(
                    icon: Icons.confirmation_number_outlined,
                    label: 'ISBN',
                    value: book.isbn,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: isLibrarian
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          elevation: 4,
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        icon: const Icon(Icons.edit, color: Colors.white),
                        label: const Text('Edit Book',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditBookScreen(book: book),
                            ),
                          );
                          if (context.mounted) ref.invalidate(booksProvider);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          elevation: 4,
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        icon: const Icon(Icons.delete, color: Colors.white),
                        label: const Text('Delete Book',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Book'),
                              content: const Text(
                                  'Are you sure you want to delete this book?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Delete',
                                      style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            final supabase = Supabase.instance.client;
                            await supabase
                                .from('books')
                                .delete()
                                .eq('id', book.id);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Book deleted!'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              Navigator.pop(context);
                              ref.invalidate(booksProvider);
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 4,
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () async {
                          final success = await ref
                              .read(requestProvider)
                              .addRequest(book.id);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(success
                                    ? 'Request sent!'
                                    : 'Failed to send request.'),
                                backgroundColor:
                                    success ? Colors.green : Colors.red,
                              ),
                            );
                          }
                        },
                        child: Text(
                          'Request Book',
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black54,
                ),
          ),
          Text(value,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.black87)),
        ],
      ),
    );
  }
}
