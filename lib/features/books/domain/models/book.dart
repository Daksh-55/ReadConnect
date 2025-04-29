class Book {
  final String id;
  final String title;
  final String author;
  final String description;
  final String category;
  final int year;
  final String isbn;
  final bool isAvailable;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.category,
    required this.year,
    required this.isbn,
    required this.isAvailable,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      year: json['year'] as int,
      isbn: json['isbn'] as String,
      isAvailable: json['is_available'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'category': category,
      'year': year,
      'isbn': isbn,
      'is_available': isAvailable,
    };
  }
}
