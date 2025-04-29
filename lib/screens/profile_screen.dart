import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readconnect/features/auth/presentation/providers/auth_provider.dart';
import '../core/providers/auth_provider.dart' as core_auth;
import 'auth/edit_profile_screen.dart';
import 'auth/settings_screen.dart';
import 'auth/about_us_screen.dart';
import 'auth/reset_password_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsync = ref.watch(core_auth.userProfileProvider);
    final userRoleAsync = ref.watch(userRoleProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.blue),
            onPressed: () async {
              final result = await ref
                  .read(core_auth.authControllerProvider.notifier)
                  .signOut();
              if (context.mounted) {
                if (result.hasError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Logout failed: \\${result.error}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Logged out successfully.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/login', (route) => false);
                }
              }
            },
          ),
        ],
      ),
      body: userProfileAsync.when(
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('No profile data found.'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      (profile['name']?.isNotEmpty == true
                          ? profile['name'][0].toUpperCase()
                          : '?'),
                      style: const TextStyle(fontSize: 40, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _ProfileSection(
                  title: 'Account Information',
                  children: [
                    _ProfileItem(
                      icon: Icons.person,
                      label: 'Name',
                      value: profile['name'] ?? 'No name',
                    ),
                    _ProfileItem(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: profile['email'] ?? 'No email',
                    ),
                    _ProfileItem(
                      icon: Icons.person_outline,
                      label: 'Role',
                      value: profile['role'] ?? 'Unknown',
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _ProfileSection(
                  title: 'Account Actions',
                  children: [
                    ListTile(
                      leading:
                          const Icon(Icons.edit_outlined, color: Colors.blue),
                      title: const Text('Edit Profile'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfileScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading:
                          const Icon(Icons.lock_outline, color: Colors.blue),
                      title: const Text('Reset Password'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ResetPasswordScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _ProfileSection(
                  title: 'Settings',
                  children: [
                    ListTile(
                      leading: const Icon(Icons.settings, color: Colors.blue),
                      title: const Text('Settings'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _ProfileSection(
                  title: 'About Us',
                  children: [
                    ListTile(
                      leading:
                          const Icon(Icons.info_outline, color: Colors.blue),
                      title: const Text('About Us'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AboutUsScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _ProfileSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Card(child: Column(children: children)),
      ],
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(label),
      subtitle: Text(value),
    );
  }
}
