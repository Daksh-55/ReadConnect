import 'package:flutter/material.dart';
import 'package:readconnect/screens/reader/books_screen.dart';
import 'package:readconnect/screens/reader/search_screen.dart';
import 'package:readconnect/screens/reader/reader_profile_screen.dart';
import 'package:readconnect/screens/reader/reader_requests_screen.dart';

class ReaderHomeScreen extends StatefulWidget {
  const ReaderHomeScreen({super.key});

  @override
  State<ReaderHomeScreen> createState() => _ReaderHomeScreenState();
}

class _ReaderHomeScreenState extends State<ReaderHomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const BooksScreen(),
    const SearchScreen(),
    const ReaderRequestsScreen(),
    const ReaderProfileScreen(),
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
            icon: Icon(Icons.home_outlined, color: Colors.blue),
            selectedIcon: Icon(Icons.home, color: Colors.blue),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined, color: Colors.blue),
            selectedIcon: Icon(Icons.search, color: Colors.blue),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined, color: Colors.blue),
            selectedIcon: Icon(Icons.assignment, color: Colors.blue),
            label: 'Requests',
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
