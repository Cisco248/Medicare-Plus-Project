import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity.model.freezed.dart';
part 'activity.model.g.dart';

enum ActivityType { footSteps, heartBeat }

@freezed
abstract class ActivityModel with _$ActivityModel {
  const factory ActivityModel({
    @Default(0) int steps,
    @Default(0) int walking,
    @Default(0) int running,
    @Default(0) int climbing,
    @Default(0) int sleeping,
  }) = _ActivityModel;

  factory ActivityModel.fromJson(Map<String, Object?> json) =>
      _$ActivityModelFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$ActivityModelToJson(this as _ActivityModel);
}
