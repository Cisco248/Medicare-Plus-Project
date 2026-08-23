import 'package:client/feature/dashboard/notifiers/clinical_snapshot.notifier.dart';
import 'package:client/feature/dashboard/notifiers/server_health.notifier.dart';
import 'package:client/feature/dashboard/widgets/health_summary_cards.dart';
import 'package:client/feature/dashboard/widgets/knowledge.widget.dart';
import 'package:client/feature/dashboard/widgets/patient.widget.dart';
import 'package:client/feature/dashboard/widgets/remainder.widget.dart';
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
    await ref.read(clinicalSnapshotProvider.notifier).refreshDailyActivity();
  }

  @override
  Widget build(BuildContext context) {
    final trend = ref.watch(stepsTrendProvider);

    return RefreshIndicator(
      onRefresh: _refresh,
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            const PatientCard(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  const RemainderCard(),
                  const SizedBox(height: 16),
                  const TodayHealthGrid(),
                  const SizedBox(height: 12),
                  const VitalSignsCard(),
                  const SizedBox(height: 12),
                  const AiHealthSummaryCard(),
                  const SizedBox(height: 12),
                  const RiskIndicatorCard(),
                  const SizedBox(height: 12),
                  trend.when(
                    data: (value) => value == null
                        ? const SizedBox.shrink()
                        : HealthTrendChart(trend: value),
                    loading: () => const SizedBox.shrink(),
                    error: (_, _) => const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 16),
                  const KnowledgeWidget(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
