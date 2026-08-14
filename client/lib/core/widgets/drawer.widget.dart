import 'package:client/feature/auth/notifiers/authentication.notifier.dart';
import 'package:client/feature/e_doc/notifiers/document_query.notifier.dart';
import 'package:client/feature/pharmacy/page/orders.page.dart';
import 'package:client/feature/settings/notifiers/app_info.notifier.dart';
import 'package:client/feature/settings/page/about.page.dart';
import 'package:client/feature/settings/page/agreement.page.dart';
import 'package:client/feature/settings/page/permissions.page.dart';
import 'package:client/feature/settings/page/privacy.page.dart';
import 'package:client/feature/settings/page/profile.page.dart';
import 'package:client/feature/settings/page/settings.page.dart';
import 'package:client/layout/providers/navigation.notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final user = ref.watch(authenticationProvider).value?.data;
    final info = ref.watch(appInfoProvider);

    return Drawer(
      backgroundColor: colorScheme.surface,
      child: SafeArea(
        child: ListView(
          children: [
            DrawerHeader(
              margin: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.health_and_safety_rounded, color: colorScheme.primary, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    'MediCare Plus',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.name ?? 'Signed in user',
                    style: const TextStyle(fontFamily: 'Inter', fontSize: 13),
                  ),
                  if (user?.email != null)
                    Text(
                      user!.email,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: colorScheme.onSurface.withAlpha(150),
                      ),
                    ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text('MAIN NAVIGATION', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
            ),
            _tab(context, ref, icon: const FaIcon(FontAwesomeIcons.houseChimneyMedical, size: 16), label: 'Dashboard', index: 0),
            _tab(context, ref, icon: const FaIcon(FontAwesomeIcons.userDoctor, size: 16), label: 'E-Doc', index: 2),
            _tab(context, ref, icon: const FaIcon(FontAwesomeIcons.briefcaseMedical, size: 16), label: 'E-Pharmacy', index: 3),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.boxOpen, size: 16),
              title: const Text('Orders'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OrdersPage()));
              },
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.filePrescription, size: 16),
              title: const Text('Prescriptions'),
              onTap: () {
                Navigator.of(context).pop();
                ref.read(documentQueryProvider.notifier).setDocType('Prescription');
                ref.read(navigationProvider.notifier).changeIndex(2);
              },
            ),
            _tab(context, ref, icon: const FaIcon(FontAwesomeIcons.fileMedical, size: 16), label: 'Reports', index: 4),
            const Divider(),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text('ACCOUNT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
            ),
            _push(context, icon: const FaIcon(FontAwesomeIcons.user, size: 16), label: 'Profile', page: const ProfilePage()),
            _push(context, icon: const FaIcon(FontAwesomeIcons.gear, size: 16), label: 'Settings', page: const SettingsPage()),
            const Divider(),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text('APP INFORMATION', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
            ),
            _push(context, icon: const FaIcon(FontAwesomeIcons.shieldHalved, size: 16), label: 'Permissions', page: const PermissionsPage()),
            _push(context, icon: const FaIcon(FontAwesomeIcons.lock, size: 16), label: 'Privacy Statement', page: const PrivacyStatementPage()),
            _push(context, icon: const FaIcon(FontAwesomeIcons.fileLines, size: 16), label: 'User Agreement', page: const UserAgreementPage()),
            _push(context, icon: const FaIcon(FontAwesomeIcons.circleInfo, size: 16), label: 'About', page: const AboutPage()),
            info.when(
              data: (value) => ListTile(
                leading: const FaIcon(FontAwesomeIcons.codeBranch, size: 16),
                title: const Text('App Version'),
                subtitle: Text('${value.appName}\n${value.versionLabel}'),
                isThreeLine: true,
              ),
              loading: () => const ListTile(title: Text('App Version')),
              error: (_, _) => const ListTile(
                title: Text('App Version'),
                subtitle: Text('MediCare Plus\nVersion 1.0.0 (1)'),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.rightFromBracket, size: 16),
              title: const Text('Logout'),
              onTap: () {
                Navigator.of(context).pop();
                ref.read(authenticationProvider.notifier).logout();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _tab(
    BuildContext context,
    WidgetRef ref, {
    required Widget icon,
    required String label,
    required int index,
  }) {
    return ListTile(
      leading: icon,
      title: Text(label),
      onTap: () {
        Navigator.of(context).pop();
        ref.read(navigationProvider.notifier).changeIndex(index);
      },
    );
  }

  Widget _push(
    BuildContext context, {
    required Widget icon,
    required String label,
    required Widget page,
  }) {
    return ListTile(
      leading: icon,
      title: Text(label),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
      },
    );
  }
}
