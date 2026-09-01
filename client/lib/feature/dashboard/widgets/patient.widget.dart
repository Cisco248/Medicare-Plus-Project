import 'package:client/core/themes/primitives/spacing.dart';
import 'package:client/core/utils/body_metrics.dart';
import 'package:client/core/widgets/avatar.widget.dart';
import 'package:client/core/widgets/glass.widget.dart';
import 'package:client/feature/auth/notifiers/authentication.notifier.dart';
import 'package:client/feature/dashboard/notifiers/clinical_snapshot.notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PatientCard extends ConsumerWidget {
  const PatientCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final userData = ref.watch(authenticationProvider);
    final snapshot = ref.watch(clinicalSnapshotProvider);
    final profile = snapshot.profile;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        ZintraSpacing.pageMargin,
        ZintraSpacing.sm,
        ZintraSpacing.pageMargin,
        0,
      ),
      child: userData.when(
        loading: () => const GlassContainer(
          child: SizedBox(height: 96, child: _PatientSkeleton()),
        ),
        error: (_, _) => GlassContainer(
          child: Text(
            'Unable to load your profile.',
            style: TextStyle(fontFamily: 'Inter', color: cs.error),
          ),
        ),
        data: (user) {
          final name = (profile?.name.trim().isNotEmpty == true)
              ? profile!.name.trim()
              : (user.data?.name.trim().isNotEmpty == true)
              ? user.data!.name.trim()
              : 'Your profile';
          final age = snapshot.age.value;
          final gender = snapshot.gender.value;
          final height = snapshot.heightCm.value;
          final weight = snapshot.weightKg.value;
          final bmi = snapshot.bmi.value;
          final conditions = profile?.conditions ?? const [];

          return GlassContainer(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ZintraAvatar(size: 64, initials: _initials(name)),
                const SizedBox(width: ZintraSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: cs.onSurface,
                        ),
                      ),
                      if (_metaLine(
                        age,
                        gender,
                        height,
                        weight,
                        bmi,
                      ).isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          _metaLine(age, gender, height, weight, bmi),
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                      if (conditions.isNotEmpty) ...[
                        const SizedBox(height: ZintraSpacing.xs),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            for (final condition in conditions.take(4))
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: cs.primary.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(
                                    ZintraSpacing.radiusLg,
                                  ),
                                  border: Border.all(
                                    color: cs.outline.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Text(
                                  condition.label.isEmpty
                                      ? condition.code
                                      : condition.label,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 11,
                                    color: cs.onSurface,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _initials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first[0];
    return '${parts.first[0]}${parts.last[0]}';
  }

  String _metaLine(
    int? age,
    String? gender,
    double? height,
    double? weight,
    double? bmi,
  ) {
    final parts = <String>[];
    if (age != null) parts.add('$age yrs');
    if (gender != null && gender.isNotEmpty) parts.add(gender);
    if (height != null) parts.add('${height.toStringAsFixed(0)} cm');
    if (weight != null) parts.add('${weight.toStringAsFixed(1)} kg');
    final formattedBmi = BodyMetrics.formatBmi(bmi);
    if (formattedBmi != null) parts.add('BMI $formattedBmi');
    return parts.join('  ·  ');
  }
}

class _PatientSkeleton extends StatelessWidget {
  const _PatientSkeleton();

  @override
  Widget build(BuildContext context) {
    final fill = Theme.of(context).colorScheme.outline.withValues(alpha: 0.18);
    return Row(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(color: fill, shape: BoxShape.circle),
        ),
        const SizedBox(width: ZintraSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 14,
                width: 140,
                decoration: BoxDecoration(
                  color: fill,
                  borderRadius: BorderRadius.circular(ZintraSpacing.radiusFull),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 10,
                width: 200,
                decoration: BoxDecoration(
                  color: fill,
                  borderRadius: BorderRadius.circular(ZintraSpacing.radiusFull),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
