import 'package:client/core/widgets/avatar.widget.dart';
import 'package:client/core/widgets/card.widget.dart';
import 'package:client/feature/auth/notifiers/authentication.notifier.dart';
import 'package:client/feature/dashboard/notifiers/clinical_snapshot.notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PatientCard extends ConsumerWidget {
  const PatientCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).colorScheme;
    final userData = ref.watch(authenticationProvider);
    final snapshot = ref.watch(clinicalSnapshotProvider);
    final age = snapshot.age.value;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: theme.primaryFixedDim,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(64),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: userData.when(
        data: (user) {
          final name = user.data?.name.trim();
          final displayName = (name == null || name.isEmpty)
              ? 'Your profile'
              : name;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              ZintraAvatar(
                size: 96,
                initials: displayName.isEmpty ? '' : displayName[0],
              ),
              ZintraCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 8,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Email: ${user.data?.email ?? '—'}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    if (age != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Age: $age',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
        error: (_, _) =>
            const Center(child: Text('Unable to load your profile.')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
