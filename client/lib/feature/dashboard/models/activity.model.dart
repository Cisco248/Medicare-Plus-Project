import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity.model.freezed.dart';

enum ActivityType { footSteps, heartBeat }

@freezed
abstract class ActivityModel with _$ActivityModel {
  const factory ActivityModel({
    required ActivityType type,
    required DateTime createdTime,
  }) = _ActivityModel;
}
