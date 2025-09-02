import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/role_selection_screen.dart';
import 'screens/reader/reader_home_screen.dart';
import 'screens/librarian/librarian_home_screen.dart';
import 'screens/auth/reset_password_screen.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://qkofhjpafqyuamcaqacv.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFrb2ZoanBhZnF5dWFtY2FxYWN2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY4NDU4MDMsImV4cCI6MjA3MjQyMTgwM30.J0phNXiL0IiuB7kSbAmya3jtmovxaQzl5awUyAojiGg',
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReadConnect',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF18161F),
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/reset-password': (context) => const ResetPasswordScreen(),
        '/reader': (context) => const ReaderHomeScreen(),
        '/librarian': (context) => const LibrarianHomeScreen(),
      },
    );
  }
}
