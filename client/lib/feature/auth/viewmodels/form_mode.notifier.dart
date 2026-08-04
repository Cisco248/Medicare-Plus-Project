import 'package:client/feature/auth/models/form.model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'form_mode.notifier.g.dart';

@riverpod
class FormStateNotifier extends _$FormStateNotifier {
  @override
  FormStatus build() {
    return FormStatus(state: FormMode.signIn);
  }

  void toggle() {
    state = state.copyWith(
      state: state.state == FormMode.signIn ? FormMode.signUp : FormMode.signIn,
    );
  }
}
