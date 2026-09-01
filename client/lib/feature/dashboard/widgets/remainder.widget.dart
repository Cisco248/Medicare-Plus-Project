import 'package:client/core/themes/primitives/spacing.dart';
import 'package:client/core/widgets/glass.widget.dart';
import 'package:client/feature/dashboard/models/patient_profile.model.dart';
import 'package:client/feature/dashboard/notifiers/clinical_snapshot.notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RemainderCard extends ConsumerWidget {
  const RemainderCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final profile = ref.watch(patientProfileProvider);

    return profile.when(
      loading: () => const GlassContainer(
        child: SizedBox(height: 72, child: _ReminderSkeleton()),
      ),
      error: (_, _) => GlassContainer(
        child: _EmptyReminder(
          title: 'Unable to load reminders',
          message: 'Try again after refreshing the dashboard.',
          colorScheme: cs,
        ),
      ),
      data: (value) {
        final medications = value?.medications ?? const <PatientMedication>[];
        if (medications.isEmpty) {
          return GlassContainer(
            child: _EmptyReminder(
              title: 'No upcoming appointments',
              message: "You're all caught up.",
              colorScheme: cs,
            ),
          );
        }

        final shown = medications.take(3).toList();
        return GlassContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reminders',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: ZintraSpacing.xs),
              Text(
                'From your saved medication list',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: cs.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: ZintraSpacing.sm),
              for (var i = 0; i < shown.length; i++) ...[
                _MedicationRow(medication: shown[i]),
                if (i < shown.length - 1)
                  const SizedBox(height: ZintraSpacing.xs),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _MedicationRow extends StatelessWidget {
  const _MedicationRow({required this.medication});

  final PatientMedication medication;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final details = [
      if (medication.dosage != null && medication.dosage!.trim().isNotEmpty)
        medication.dosage!.trim(),
      if (medication.frequency != null &&
          medication.frequency!.trim().isNotEmpty)
        medication.frequency!.trim(),
    ].join('  ·  ');

    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: cs.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(ZintraSpacing.radiusMd),
          ),
          child: Center(
            child: FaIcon(FontAwesomeIcons.pills, size: 14, color: cs.primary),
          ),
        ),
        const SizedBox(width: ZintraSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                medication.name,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
              ),
              if (details.isNotEmpty)
                Text(
                  details,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    color: cs.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EmptyReminder extends StatelessWidget {
  const _EmptyReminder({
    required this.title,
    required this.message,
    required this.colorScheme,
  });

  final String title;
  final String message;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FaIcon(
          FontAwesomeIcons.calendarCheck,
          size: 18,
          color: colorScheme.primary,
        ),
        const SizedBox(width: ZintraSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                message,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReminderSkeleton extends StatelessWidget {
  const _ReminderSkeleton();

  @override
  Widget build(BuildContext context) {
    final fill = Theme.of(context).colorScheme.outline.withValues(alpha: 0.18);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 12,
          width: 160,
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(ZintraSpacing.radiusFull),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 10,
          width: 220,
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(ZintraSpacing.radiusFull),
          ),
        ),
      ],
    );
  }
}
