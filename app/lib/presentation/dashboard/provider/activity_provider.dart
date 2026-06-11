import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';

// class ActivityNotifier extends Notifier<List> {
//   // final hourlyTrackingData = ;
//
//   @override
//   List build() => [];
//
//   void refreshList(List index) {
//     state = index;
//   }
// }
//
// final navigationProvider = NotifierProvider<ActivityNotifier, List>(
//   ActivityNotifier.new,
// );

final accelerometerProvider = StreamProvider<AccelerometerEvent>((ref) {
  return accelerometerEventStream();
});
