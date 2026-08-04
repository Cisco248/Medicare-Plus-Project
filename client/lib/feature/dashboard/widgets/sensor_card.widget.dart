// import 'package:app/presentation/dashboard/provider/activity_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class SensorData extends StatelessWidget {
//   const SensorData({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer(
//       builder: (context, ref, child) {
//         final sensor = ref.watch(accelerometerProvider);
//         return sensor.when(
//           data: (event) => Text(
//             'X: ${event.x.toStringAsFixed(3)}\n'
//             'Y: ${event.y.toStringAsFixed(3)}\n'
//             'Z: ${event.z.toStringAsFixed(3)}',
//           ),
//           loading: () => const CircularProgressIndicator(),
//           error: (e, _) => Text('Error: $e'),
//         );
//       },
//     );
//   }
// }
