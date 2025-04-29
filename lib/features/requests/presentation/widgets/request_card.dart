import 'package:flutter/material.dart';
import 'package:readconnect/features/requests/domain/models/request_model.dart';
import 'package:readconnect/features/books/domain/models/book_model.dart';

class RequestCard extends StatelessWidget {
  final BookRequest request;
  final Book book;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final bool showActions;

  const RequestCard({
    super.key,
    required this.request,
    required this.book,
    this.onApprove,
    this.onReject,
    this.showActions = false,
  });

  Color _getStatusColor(String status) {
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'by ${book.author}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(request.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    request.status.toUpperCase(),
                    style: TextStyle(
                      color: _getStatusColor(request.status),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: Colors.blue,
                ),
                const SizedBox(width: 4),
                Text(
                  'Requested on ${_formatDate(request.requestDate)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            if (request.approvalDate != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 16,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${request.status == 'approved' ? 'Approved' : 'Rejected'} on ${_formatDate(request.approvalDate!)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
            if (showActions && request.status == 'pending') ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: onReject, child: const Text('Reject')),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: onApprove,
                    child: const Text('Approve'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
