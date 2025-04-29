class BookRequest {
  final String id;
  final String bookId;
  final String userId;
  final String status;
  final DateTime requestDate;
  final DateTime? approvalDate;
  final DateTime? returnDate;
  final String? librarianId;
  final String? librarianName;
  final String? requesterName;

  BookRequest({
    required this.id,
    required this.bookId,
    required this.userId,
    required this.status,
    required this.requestDate,
    this.approvalDate,
    this.returnDate,
    this.librarianId,
    this.librarianName,
    this.requesterName,
  });

  factory BookRequest.fromJson(Map<String, dynamic> json) {
    return BookRequest(
      id: json['id'] as String,
      bookId: json['book_id'] as String,
      userId: json['user_id'] as String,
      status: json['status'] as String,
      requestDate: DateTime.parse(json['request_date'] as String),
      approvalDate: json['approval_date'] != null
          ? DateTime.parse(json['approval_date'] as String)
          : null,
      returnDate: json['return_date'] != null
          ? DateTime.parse(json['return_date'] as String)
          : null,
      librarianId: json['librarian_id'] as String?,
      librarianName: json['users']?['name'] as String?,
      requesterName: json['users']?['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'book_id': bookId,
      'user_id': userId,
      'status': status,
      'request_date': requestDate.toIso8601String(),
      'approval_date': approvalDate?.toIso8601String(),
      'return_date': returnDate?.toIso8601String(),
      'librarian_id': librarianId,
      if (librarianName != null) 'librarian_name': librarianName,
      if (requesterName != null) 'requester_name': requesterName,
    };
  }

  BookRequest copyWith({
    String? id,
    String? bookId,
    String? userId,
    String? status,
    DateTime? requestDate,
    DateTime? approvalDate,
    DateTime? returnDate,
    String? librarianId,
    String? librarianName,
    String? requesterName,
  }) {
    return BookRequest(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      requestDate: requestDate ?? this.requestDate,
      approvalDate: approvalDate ?? this.approvalDate,
      returnDate: returnDate ?? this.returnDate,
      librarianId: librarianId ?? this.librarianId,
      librarianName: librarianName ?? this.librarianName,
      requesterName: requesterName ?? this.requesterName,
    );
  }
}
