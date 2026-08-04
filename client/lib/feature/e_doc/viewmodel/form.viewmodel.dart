import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'form.viewmodel.g.dart';

@riverpod
class FormState extends _$FormState {
  @override
  String build() {
    return 'Diabetes';
  }

  void changeStatus(String newStatus) {
    if (newStatus == 'Diabetes') {
      state = 'Diabetes';
    } else if (newStatus == 'Hypertension') {
      state = 'Hypertension';
    } else {
      state = 'Blood Pressure';
    }
  }
}
