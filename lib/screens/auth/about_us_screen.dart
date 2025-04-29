import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Us')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'About Us',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 18),
              Text(
                'Welcome to ReadConnect — a platform built to revolutionize the connection between libraries and readers.\n\n'
                'In today\'s fast-moving world, we believe access to knowledge should be simple, organized, and efficient. That\'s why we created ReadConnect — an easy-to-use platform where libraries can manage their book collections and readers can explore and request books with just a few taps.\n\n'
                'For Libraries:\nReadConnect offers an effortless way for libraries to update their book catalogs, manage availability, and keep accurate records. Instead of dealing with outdated logs and manual tracking, libraries can now maintain a live, digital inventory, helping them stay organized and making book management smoother than ever before.\n\n'
                'For Readers:\nReadConnect gives readers instant access to their local libraries\' collections. Before visiting, readers can check if a book is available, request it, and even discover new books they might love. No more wasted trips or endless searching — just simple, direct access to the knowledge they seek.\n\n'
                'Our mission is to create a stronger, smarter bond between libraries and readers, helping libraries modernize their systems while giving readers a better, more informed experience. Whether you\'re managing thousands of books or searching for your next read, ReadConnect is here to make the journey easier, faster, and more connected.\n\n'
                'Join us in building a community where every book finds its reader and every reader finds their book.\n\n'
                'ReadConnect — Connecting Libraries. Empowering Readers.',
                style: TextStyle(fontSize: 16, height: 1.6),
              ),
              SizedBox(height: 32),
              Text('Version 1.6', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
