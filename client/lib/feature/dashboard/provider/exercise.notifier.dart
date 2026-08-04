import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'exercise.notifier.g.dart';

final excercises = [
  'Jumping Jacks - 1 minute',
  'Arm Circles - 1 minute',
  'Shoulder rolls: 30 seconds',
  'High Knees - 1 minute',
  'Gentle leg swings: 30 seconds per leg',
];

final excersice02 = [
  'Brisk walking',
  'Cycling',
  'Swimming',
  'Elliptical trainer',
  'Dancing',
];

@riverpod
class CardioExerciseNotifier extends _$CardioExerciseNotifier {
  @override
  List<String> build() {
    return excercises;
  }
}

@riverpod
class WarmUpExerciseNotifier extends _$WarmUpExerciseNotifier {
  @override
  List<String> build() {
    return excersice02;
  }
}
