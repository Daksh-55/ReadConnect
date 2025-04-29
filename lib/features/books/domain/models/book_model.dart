class Book {
  final String id;
  final String title;
  final String author;
  final String description;
  final int totalCopies;
  final int availableCopies;
  final String category;
  final DateTime publishedDate;
  final String isbn;
  final String? librarianName;
  final String? libraryName;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.totalCopies,
    required this.availableCopies,
    required this.category,
    required this.publishedDate,
    required this.isbn,
    this.librarianName,
    this.libraryName,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    print(json); // Debug: print the raw JSON for each book
    return Book(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      author: json['author'] as String? ?? '',
      description: json['description'] as String? ?? '',
      totalCopies: json['total_copies'] as int? ?? 0,
      availableCopies: json['available_copies'] as int? ?? 0,
      category: json['category'] as String? ?? '',
      publishedDate: json['published_date'] != null
          ? DateTime.parse(json['published_date'])
          : DateTime(2000),
      isbn: json['isbn'] as String? ?? '',
      librarianName: (json['users:owner_id'] != null &&
              (json['users:owner_id']['name'] as String?)?.isNotEmpty == true)
          ? json['users:owner_id']['name'] as String
          : 'Unknown Library',
      libraryName: json['library_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'total_copies': totalCopies,
      'available_copies': availableCopies,
      'category': category,
      'published_date': publishedDate.toIso8601String(),
      'isbn': isbn,
      if (librarianName != null) 'librarian_name': librarianName,
      if (libraryName != null) 'library_name': libraryName,
    };
  }

  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? description,
    int? totalCopies,
    int? availableCopies,
    String? category,
    DateTime? publishedDate,
    String? isbn,
    String? librarianName,
    String? libraryName,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      totalCopies: totalCopies ?? this.totalCopies,
      availableCopies: availableCopies ?? this.availableCopies,
      category: category ?? this.category,
      publishedDate: publishedDate ?? this.publishedDate,
      isbn: isbn ?? this.isbn,
      librarianName: librarianName ?? this.librarianName,
      libraryName: libraryName ?? this.libraryName,
    );
  }
}
