class BookRequest {
  final String id;
  final String userId;
  final String bookId;
  final String status;
  final DateTime requestedAt;
  final DateTime? approvedAt;
  final DateTime? rejectedAt;

  BookRequest({
    required this.id,
    required this.userId,
    required this.bookId,
    required this.status,
    required this.requestedAt,
    this.approvedAt,
    this.rejectedAt,
  });

  factory BookRequest.fromJson(Map<String, dynamic> json) {
    return BookRequest(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      bookId: json['book_id'] as String,
      status: json['status'] as String,
      requestedAt: DateTime.parse(json['requested_at'] as String),
      approvedAt:
          json['approved_at'] != null
              ? DateTime.parse(json['approved_at'] as String)
              : null,
      rejectedAt:
          json['rejected_at'] != null
              ? DateTime.parse(json['rejected_at'] as String)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'book_id': bookId,
      'status': status,
      'requested_at': requestedAt.toIso8601String(),
      'approved_at': approvedAt?.toIso8601String(),
      'rejected_at': rejectedAt?.toIso8601String(),
    };
  }
}
