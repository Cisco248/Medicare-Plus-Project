import 'package:client/feature/auth/notifiers/authentication.notifier.dart';
import 'package:client/feature/dashboard/models/clinical_snapshot.model.dart';
import 'package:client/feature/dashboard/models/patient_profile.model.dart';
import 'package:client/feature/dashboard/notifiers/activity.notifier.dart';
import 'package:client/feature/dashboard/notifiers/server_health.notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final patientProfileProvider = FutureProvider<PatientProfile?>((ref) async {
  final auth = ref.watch(authenticationProvider).value?.data;
  if (auth == null || auth.token.isEmpty) return null;
  try {
    return await ref
        .read(harRepositoryProvider)
        .fetchProfile(token: auth.token);
  } catch (_) {
    return PatientProfile(
      id: auth.id,
      name: auth.name,
      email: auth.email,
      mobnum: auth.mobnum,
    );
  }
});

class ClinicalSnapshotNotifier extends Notifier<ClinicalSnapshot> {
  @override
  ClinicalSnapshot build() {
    return ClinicalSnapshot(
      profile: ref.watch(patientProfileProvider).asData?.value,
      activity: ref.watch(activityProvider).activity,
      serverSummary: ref.watch(serverDailySummaryProvider).asData?.value,
    );
  }

  Future<void> refreshDailyActivity() async {
    await ref.read(activityProvider.notifier).refresh();
    ref.invalidate(serverDailySummaryProvider);
    ref.invalidate(stepsTrendProvider);
  }
}

final clinicalSnapshotProvider =
    NotifierProvider<ClinicalSnapshotNotifier, ClinicalSnapshot>(
      ClinicalSnapshotNotifier.new,
    );
