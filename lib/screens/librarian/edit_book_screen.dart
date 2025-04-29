import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/books/domain/models/book_model.dart';

class EditBookScreen extends StatefulWidget {
  final Book book;
  const EditBookScreen({Key? key, required this.book}) : super(key: key);

  @override
  State<EditBookScreen> createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _authorController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _categoryController;
  late final TextEditingController _copiesController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.book.title);
    _authorController = TextEditingController(text: widget.book.author);
    _descriptionController =
        TextEditingController(text: widget.book.description);
    _categoryController = TextEditingController(text: widget.book.category);
    _copiesController =
        TextEditingController(text: widget.book.totalCopies.toString());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _copiesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final supabase = Supabase.instance.client;
    final now = DateTime.now().toUtc();
    await supabase.from('books').update({
      'title': _titleController.text,
      'author': _authorController.text,
      'description': _descriptionController.text,
      'category': _categoryController.text,
      'total_copies': int.tryParse(_copiesController.text) ?? 1,
      'updated_at': now.toIso8601String(),
    }).eq('id', widget.book.id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Book updated!'), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Book')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _authorController,
              decoration: const InputDecoration(labelText: 'Author'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _copiesController,
              decoration: const InputDecoration(labelText: 'Total Copies'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _save,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
