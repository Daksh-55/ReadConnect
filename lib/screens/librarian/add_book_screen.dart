import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/book_provider.dart';
import '../../features/books/data/repositories/book_repository.dart';
import '../../core/providers/app_providers.dart';
import '../../screens/librarian/books_screen.dart';

class AddBookScreen extends ConsumerStatefulWidget {
  const AddBookScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends ConsumerState<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _copiesController = TextEditingController(text: '1');
  final _libraryNameController = TextEditingController();
  final List<String> _categories = [
    '1st year',
    'phython',
    'java',
    'c/c++',
    'Ai',
    'ds',
    'Networking',
    'hacking',
  ];
  String? _selectedCategory;

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _copiesController.dispose();
    _libraryNameController.dispose();
    super.dispose();
  }

  Future<void> _addBook() async {
    if (_formKey.currentState?.validate() ?? false) {
      final notifier = ref.read(bookProvider.notifier);
      await notifier.addBook(
        title: _titleController.text,
        author: _authorController.text,
        description: _descriptionController.text,
        category: _selectedCategory ?? _categoryController.text,
        totalCopies: int.tryParse(_copiesController.text) ?? 1,
        libraryName: _libraryNameController.text,
      );
      final state = ref.read(bookProvider);
      if (state.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(state.error.toString()),
              backgroundColor: Colors.red),
        );
        return;
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Book added successfully!'),
              backgroundColor: Colors.green),
        );
        ref.invalidate(booksProvider);
        await Future.delayed(const Duration(milliseconds: 800));
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const BooksScreen(),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Book')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter title' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _authorController,
                  decoration: const InputDecoration(labelText: 'Author'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter author' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items: _categories
                      .map((cat) => DropdownMenuItem(
                            value: cat,
                            child: Text(cat),
                          ))
                      .toList(),
                  onChanged: (val) => setState(() => _selectedCategory = val),
                  decoration: const InputDecoration(labelText: 'Category'),
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Select a category'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _copiesController,
                  decoration: const InputDecoration(labelText: 'Total Copies'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Enter total copies'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _libraryNameController,
                  decoration: const InputDecoration(labelText: 'Library Name'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Enter library name'
                      : null,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _addBook,
                  child: const Text('Add Book'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
