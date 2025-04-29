import 'package:flutter/material.dart';
import 'package:readconnect/screens/librarian/requests_screen.dart';
import 'package:readconnect/screens/librarian/books_screen.dart';
import 'package:readconnect/screens/librarian/librarian_profile_screen.dart';

class LibrarianHomeScreen extends StatefulWidget {
  const LibrarianHomeScreen({super.key});

  @override
  State<LibrarianHomeScreen> createState() => _LibrarianHomeScreenState();
}

class _LibrarianHomeScreenState extends State<LibrarianHomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const RequestsScreen(),
    const BooksScreen(),
    const LibrarianProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined, color: Colors.blue),
            selectedIcon: Icon(Icons.notifications, color: Colors.blue),
            label: 'Requests',
          ),
          NavigationDestination(
            icon: Icon(Icons.book_outlined, color: Colors.blue),
            selectedIcon: Icon(Icons.book, color: Colors.blue),
            label: 'Books',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline, color: Colors.blue),
            selectedIcon: Icon(Icons.person, color: Colors.blue),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
