import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readconnect/features/auth/presentation/providers/auth_provider.dart';
import 'package:readconnect/screens/librarian/librarian_home_screen.dart';
import 'package:readconnect/screens/reader/reader_home_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRoleAsync = ref.watch(userRoleProvider);

    return userRoleAsync.when(
      data: (role) {
        if (role == 'librarian') {
          return const LibrarianHomeScreen();
        } else if (role == 'reader') {
          return const ReaderHomeScreen();
        }
        return const Scaffold(
          body: Center(child: Text('Invalid user role')),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
    );
  }
}
