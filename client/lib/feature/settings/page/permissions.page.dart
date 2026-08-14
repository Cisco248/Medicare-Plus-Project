import 'package:client/feature/settings/notifiers/permissions.notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PermissionsPage extends ConsumerWidget {
  const PermissionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissions = ref.watch(permissionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Permissions',
          style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: permissions.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(
          child: FilledButton.tonal(
            onPressed: () => ref.read(permissionsProvider.notifier).refresh(),
            child: const Text('Retry'),
          ),
        ),
        data: (items) => ListView(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Only permissions this app actually uses are listed. New permissions are not requested from this screen unless you choose to manage Health Connect.',
                style: TextStyle(fontFamily: 'Inter', fontSize: 12),
              ),
            ),
            ...items.map((item) {
              return ListTile(
                title: Text(item.title),
                subtitle: Text('${item.subtitle}\nStatus: ${item.statusLabel}'),
                isThreeLine: true,
                trailing: item.kind == AppPermissionKind.healthConnect
                    ? TextButton(
                        onPressed: item.status == AppPermissionStatus.unavailable
                            ? null
                            : () => item.status == AppPermissionStatus.notAllowed
                                ? ref.read(permissionsProvider.notifier).requestHealthConnect()
                                : ref.read(permissionsProvider.notifier).manageHealthConnect(),
                        child: Text(
                          item.status == AppPermissionStatus.notAllowed
                              ? 'Allow'
                              : 'Manage',
                        ),
                      )
                    : null,
              );
            }),
          ],
        ),
      ),
    );
  }
}
