import 'package:client/core/themes/theme_provider.dart';
import 'package:client/feature/settings/notifiers/app_info.notifier.dart';
import 'package:client/feature/settings/page/about.page.dart';
import 'package:client/feature/settings/page/agreement.page.dart';
import 'package:client/feature/settings/page/permissions.page.dart';
import 'package:client/feature/settings/page/privacy.page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final info = ref.watch(appInfoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark appearance'),
            subtitle: const Text('Uses the existing app theme toggle.'),
            value: themeMode.isDark,
            onChanged: (_) => ref.read(themeProvider.notifier).toggle(),
          ),
          ListTile(
            title: const Text('Theme'),
            subtitle: Text(themeMode.name),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _pickTheme(context, ref),
          ),
          const Divider(),
          ListTile(
            title: const Text('Permissions'),
            onTap: () => _open(context, const PermissionsPage()),
          ),
          ListTile(
            title: const Text('Privacy statement'),
            onTap: () => _open(context, const PrivacyStatementPage()),
          ),
          ListTile(
            title: const Text('User agreement'),
            onTap: () => _open(context, const UserAgreementPage()),
          ),
          ListTile(
            title: const Text('About'),
            onTap: () => _open(context, const AboutPage()),
          ),
          const Divider(),
          ListTile(
            title: const Text('Notifications'),
            subtitle: const Text('Push notifications are not available in this version.'),
            enabled: false,
          ),
          ListTile(
            title: const Text('Language'),
            subtitle: const Text('English only in this version.'),
            enabled: false,
          ),
          info.when(
            data: (value) => ListTile(
              title: Text(value.appName),
              subtitle: Text(value.versionLabel),
            ),
            loading: () => const ListTile(title: Text('Loading version...')),
            error: (_, _) => const ListTile(title: Text('MediCare Plus')),
          ),
        ],
      ),
    );
  }

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  Future<void> _pickTheme(BuildContext context, WidgetRef ref) async {
    final selected = await showModalBottomSheet<ThemeMode>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('System'),
              onTap: () => Navigator.pop(context, ThemeMode.system),
            ),
            ListTile(
              title: const Text('Light'),
              onTap: () => Navigator.pop(context, ThemeMode.light),
            ),
            ListTile(
              title: const Text('Dark'),
              onTap: () => Navigator.pop(context, ThemeMode.dark),
            ),
          ],
        ),
      ),
    );
    if (selected == null) return;
    switch (selected) {
      case ThemeMode.light:
        ref.read(themeProvider.notifier).light();
      case ThemeMode.dark:
        ref.read(themeProvider.notifier).dark();
      case ThemeMode.system:
        ref.read(themeProvider.notifier).system();
    }
  }
}
