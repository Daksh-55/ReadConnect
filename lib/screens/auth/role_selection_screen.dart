import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/providers/auth_provider.dart';

class RoleSelectionScreen extends ConsumerStatefulWidget {
  final String name;
  final String email;
  final String password;

  const RoleSelectionScreen({
    Key? key,
    required this.name,
    required this.email,
    required this.password,
  }) : super(key: key);

  @override
  ConsumerState<RoleSelectionScreen> createState() =>
      _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends ConsumerState<RoleSelectionScreen> {
  String? _selectedRole;

  Future<void> _completeSignup() async {
    if (_selectedRole == null) return;

    final result = await ref.read(authControllerProvider.notifier).signUp(
          widget.email,
          widget.password,
          _selectedRole!,
          name: widget.name,
        );

    if (result.hasError) {
      if (mounted) {
        final error = result.error.toString();
        String userMessage;
        if (error.contains('over_email_send_rate_limit')) {
          userMessage =
              'You are trying too quickly. Please wait a minute before trying again.';
        } else if (error.contains('password')) {
          userMessage = 'Password is too weak or invalid.';
        } else if (error.contains('email')) {
          userMessage = 'Invalid or already used email address.';
        } else {
          userMessage = error;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(userMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created! Please sign in.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              // Decorative top icon
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_outline_rounded,
                    size: 40,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Choose Your Role',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Select how you want to use ReadConnect',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // Reader Role Card
              _buildRoleCard(
                title: 'Reader',
                description:
                    'Browse and read books, create reading lists, and track your progress',
                icon: Icons.menu_book_rounded,
                isSelected: _selectedRole == 'reader',
                onTap: () => setState(() => _selectedRole = 'reader'),
              ),
              const SizedBox(height: 16),
              // Librarian Role Card
              _buildRoleCard(
                title: 'Librarian',
                description:
                    'Manage library inventory, handle book requests, and oversee library operations',
                icon: Icons.library_books_rounded,
                isSelected: _selectedRole == 'librarian',
                onTap: () => setState(() => _selectedRole = 'librarian'),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: _selectedRole == null || authState.isLoading
                    ? null
                    : _completeSignup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: authState.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.arrow_forward_rounded,
                        size: 20, color: Colors.blue),
                label: Text(
                  'Continue',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required String title,
    required String description,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.blue,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.blue : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Colors.blue,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
