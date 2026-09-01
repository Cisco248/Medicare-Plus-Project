import 'package:client/core/themes/primitives/spacing.dart';
import 'package:client/core/widgets/glass.widget.dart';
import 'package:client/feature/dashboard/notifiers/motion_sensor.notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MotionStatusCard extends ConsumerWidget {
  const MotionStatusCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final motion = ref.watch(motionSensorProvider);
    final status = _statusLabel(motion);
    final detail = _detailLabel(motion);
    final prediction = _predictionLabel(motion);

    return GlassContainer(
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(ZintraSpacing.radiusMd),
            ),
            child: Center(
              child: FaIcon(
                FontAwesomeIcons.personWalking,
                size: 16,
                color: cs.primary,
              ),
            ),
          ),
          const SizedBox(width: ZintraSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Motion capture',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  status,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: motion.errorMessage == null
                        ? cs.onSurfaceVariant
                        : cs.error,
                  ),
                ),
                if (detail.isNotEmpty)
                  Text(
                    detail,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                if (prediction.isNotEmpty)
                  Text(
                    prediction,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: motion.predictionError == null
                          ? cs.primary
                          : cs.error,
                    ),
                  ),
              ],
            ),
          ),
          if (motion.predicting)
            const SizedBox(
              width: 36,
              height: 36,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              tooltip: 'Recognise current activity',
              visualDensity: VisualDensity.compact,
              onPressed: () =>
                  ref.read(motionSensorProvider.notifier).predictCurrent(),
              icon: FaIcon(
                FontAwesomeIcons.personRunning,
                size: 14,
                color: cs.primary,
              ),
            ),
          if (!motion.recording)
            IconButton(
              tooltip: 'Start motion capture',
              visualDensity: VisualDensity.compact,
              onPressed: () => ref.read(motionSensorProvider.notifier).start(),
              icon: FaIcon(FontAwesomeIcons.play, size: 14, color: cs.primary),
            ),
        ],
      ),
    );
  }

  String _statusLabel(MotionSensorState motion) {
    if (motion.errorMessage != null) return motion.errorMessage!;
    if (motion.recording && motion.background) {
      return 'Recording in the background';
    }
    if (motion.recording) return 'Recording accelerometer and gyroscope';
    return 'Motion capture is off';
  }

  String _detailLabel(MotionSensorState motion) {
    if (!motion.recording && motion.storedCount <= 0) return '';
    final parts = <String>[];
    if (motion.storedCount > 0) {
      parts.add('${motion.storedCount} samples stored');
    }
    if (motion.uploading) parts.add('uploading');
    if (motion.buffered > 0) parts.add('${motion.buffered} queued');
    return parts.join('  ·  ');
  }

  String _predictionLabel(MotionSensorState motion) {
    if (motion.predictionError != null) return motion.predictionError!;
    if (motion.activity == null) return '';
    final confidence = motion.confidence;
    if (confidence == null) return motion.activity!;
    return '${motion.activity}  ·  ${(confidence * 100).round()}%';
  }
}
