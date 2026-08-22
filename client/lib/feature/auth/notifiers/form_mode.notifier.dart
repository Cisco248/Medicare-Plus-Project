import 'package:client/feature/auth/models/auth.state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'form_mode.notifier.g.dart';

@riverpod
class FormStateNotifier extends _$FormStateNotifier {
  @override
  FormStates build() {
    return FormStates(state: FormMode.signIn);
  }

  void toggle() {
    state = state.copyWith(
      state: state.state == FormMode.signIn ? FormMode.signUp : FormMode.signIn,
    );
  }
}
