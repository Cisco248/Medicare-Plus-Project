import 'package:client/core/themes/primitives/colors.dart';
import 'package:client/feature/dashboard/models/health_summary_response.model.dart';
import 'package:client/feature/dashboard/models/knowledge.state.model.dart';
import 'package:client/feature/dashboard/notifiers/activity.notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Presentation-only entry point of the health-summary feature.
///
/// Reads [KnowledgeState] from the `ActivityNotifier` and renders the
/// corresponding UI. All Health Connect and RAG interaction happens in the
/// notifier/repository layers — this widget only dispatches user intents.
class KnowledgeWidget extends ConsumerWidget {
  const KnowledgeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final state = ref.watch(activityProvider);
    final notifier = ref.read(activityProvider.notifier);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.onSurface.withAlpha(10),
            colorScheme.surfaceContainer.withAlpha(100),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        backgroundBlendMode: BlendMode.srcOver,
        shape: BoxShape.rectangle,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border: Border.all(color: ZintraColorPrimitives.transparent),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(
            onRefresh: state.isLoadingHealthData || state.isGeneratingSummary
                ? null
                : notifier.refresh,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: _buildBody(context, state, notifier),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    KnowledgeState state,
    ActivityNotifier notifier,
  ) {
    switch (state.phase) {
      case KnowledgePhase.loadingHealthData:
        return const _ProgressMessage(text: 'Analyzing your health data...');
      case KnowledgePhase.generatingSummary:
        return const _ProgressMessage(
          text: 'Generating your personalized summary...',
        );
      case KnowledgePhase.healthConnectUnavailable:
        return const _InfoMessage(
          text:
              'Health Connect is not available on this device, so a health '
              'summary cannot be generated.',
        );
      case KnowledgePhase.permissionRequired:
        return _ActionMessage(
          text:
              'To generate your personalized health summary, allow this app '
              'to read your health data in Health Connect.',
          actionLabel: 'Grant access',
          onAction: notifier.requestPermissions,
        );
      case KnowledgePhase.noHealthData:
        return _ActionMessage(
          text: 'No health data available for this period.',
          actionLabel: 'Check again',
          onAction: notifier.refresh,
        );
      case KnowledgePhase.healthDataReady:
        return _ActionMessage(
          text:
              'Your health data is ready. Generate an AI summary of your '
              'day\'s activity.',
          actionLabel: 'Generate summary',
          onAction: notifier.generateSummary,
        );
      case KnowledgePhase.summaryReady:
        final summary = state.summary;
        if (summary == null) {
          return _ActionMessage(
            text: 'No summary available yet.',
            actionLabel: 'Generate summary',
            onAction: notifier.generateSummary,
          );
        }
        return _SummaryContent(summary: summary);
      case KnowledgePhase.failure:
        return _ActionMessage(
          text: state.errorMessage ?? 'Something went wrong. Please try again.',
          actionLabel: 'Retry',
          onAction: notifier.retry,
        );
    }
  }
}

class _Header extends StatelessWidget {
  const _Header({this.onRefresh});

  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Text(
          "For the patient's health",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(width: 8),
        FaIcon(
          FontAwesomeIcons.circleQuestion,
          size: 14,
          color: colorScheme.primary,
        ),
        const Spacer(),
        IconButton(
          tooltip: 'Refresh health data',
          visualDensity: VisualDensity.compact,
          onPressed: onRefresh,
          icon: FaIcon(
            FontAwesomeIcons.arrowsRotate,
            size: 14,
            color: colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

class _ProgressMessage extends StatelessWidget {
  const _ProgressMessage({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: _BodyText(text)),
      ],
    );
  }
}

class _InfoMessage extends StatelessWidget {
  const _InfoMessage({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => _BodyText(text);
}

class _ActionMessage extends StatelessWidget {
  const _ActionMessage({
    required this.text,
    required this.actionLabel,
    required this.onAction,
  });

  final String text;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BodyText(text),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton.tonal(
            onPressed: onAction,
            child: Text(actionLabel),
          ),
        ),
      ],
    );
  }
}

class _SummaryContent extends StatelessWidget {
  const _SummaryContent({required this.summary});

  final HealthSummaryResponse summary;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final generatedAt = summary.generatedAt?.toLocal();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BodyText(summary.summary),
        if (summary.recommendations.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            'Recommendations',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          for (final recommendation in summary.recommendations)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: _BodyText('\u2022 $recommendation'),
            ),
        ],
        const SizedBox(height: 8),
        Text(
          summary.disclaimer ??
              'AI-generated informational summary — not a medical diagnosis.',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 10,
            fontStyle: FontStyle.italic,
            color: colorScheme.onPrimary.withAlpha(180),
          ),
        ),
        if (generatedAt != null) ...[
          const SizedBox(height: 4),
          Text(
            'Generated on '
            '${generatedAt.day.toString().padLeft(2, '0')}/'
            '${generatedAt.month.toString().padLeft(2, '0')}/'
            '${generatedAt.year} at '
            '${generatedAt.hour.toString().padLeft(2, '0')}:'
            '${generatedAt.minute.toString().padLeft(2, '0')}',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10,
              color: colorScheme.onPrimary.withAlpha(140),
            ),
          ),
        ],
      ],
    );
  }
}

class _BodyText extends StatelessWidget {
  const _BodyText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Text(
      text,
      textAlign: TextAlign.justify,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: colorScheme.onPrimary,
      ),
    );
  }
}
