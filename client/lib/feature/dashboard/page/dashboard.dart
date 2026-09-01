import 'package:client/core/themes/primitives/spacing.dart';
import 'package:client/feature/dashboard/notifiers/clinical_snapshot.notifier.dart';
import 'package:client/feature/dashboard/notifiers/server_health.notifier.dart';
import 'package:client/feature/dashboard/widgets/health_summary_cards.dart';
import 'package:client/feature/dashboard/widgets/knowledge.widget.dart';
import 'package:client/feature/dashboard/widgets/patient.widget.dart';
import 'package:client/feature/dashboard/widgets/remainder.widget.dart';
import 'package:client/feature/dashboard/widgets/weekly_charts.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    ref.invalidate(patientProfileProvider);
    ref.invalidate(serverPredictionProvider);
    ref.invalidate(weeklyHealthProvider);
    await ref.read(clinicalSnapshotProvider.notifier).refreshDailyActivity();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            const PatientCard(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: ZintraSpacing.pageMargin,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: ZintraSpacing.md),
                  const WeeklyHealthCharts(),
                  const SizedBox(height: ZintraSpacing.md),
                  const RemainderCard(),
                  const SizedBox(height: ZintraSpacing.md),
                  const TodayHealthGrid(),
                  const SizedBox(height: ZintraSpacing.sm),
                  const VitalSignsCard(),
                  const SizedBox(height: ZintraSpacing.sm),
                  const AiHealthSummaryCard(),
                  const SizedBox(height: ZintraSpacing.sm),
                  const ActivityTrackingCard(),
                  const SizedBox(height: ZintraSpacing.md),
                  const KnowledgeWidget(),
                  const SizedBox(height: ZintraSpacing.xl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
