class SupabaseConstants {
  /// Your Supabase project URL
  /// Get this from Project Settings > API > Project URL
  static const String url = 'https://oazllwjphlsgqbyfbrky.supabase.co';

  /// Your Supabase anonymous key
  /// Get this from Project Settings > API > Project API keys > anon public
  static const String anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9hemxsd2pwaGxzZ3FieWZicmt5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU2NTk0MDcsImV4cCI6MjA2MTIzNTQwN30.N0HD9rOTh7fulUAXiFazMGJT-ZKgXnfBiLI4NRmOk-I';

  // Table names
  static const String booksTable = 'books';
  static const String usersTable = 'users';
  static const String requestsTable = 'requests';
  static const String favoritesTable = 'favorites';

  // Storage bucket names
  static const String bookCoversBucket = 'book-covers';
}
