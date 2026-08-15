import 'package:client/feature/auth/notifiers/authentication.notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authenticationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: auth.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(child: Text('Unable to load profile.')),
        data: (status) {
          final user = status.data;
          if (user == null) {
            return const Center(child: Text('No profile information is available.'));
          }
          return ListView(
            children: [
              ListTile(title: const Text('Name'), subtitle: Text(user.name)),
              ListTile(title: const Text('Email'), subtitle: Text(user.email)),
              ListTile(title: const Text('Mobile'), subtitle: Text(user.mobnum)),
            ],
          );
        },
      ),
    );
  }
}
