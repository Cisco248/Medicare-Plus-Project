import 'package:flutter_riverpod/legacy.dart';

enum AuthFormMode { signIn, signUp }

final authFormProvider = StateProvider<AuthFormMode>(
  (ref) => AuthFormMode.signIn,
);
