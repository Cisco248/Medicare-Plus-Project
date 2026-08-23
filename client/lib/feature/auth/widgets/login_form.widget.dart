import 'package:client/core/exceptions/base.exception.dart';
import 'package:client/core/themes/primitives/colors.dart';
import 'package:client/core/utils/notification.utils.dart';
import 'package:client/core/widgets/textfield.widget.dart';
import 'package:client/feature/auth/models/auth.state.dart';
import 'package:client/feature/auth/notifiers/authentication.notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final rememberMeProvider = StateProvider<bool>((ref) => false);

class SignInForm extends ConsumerStatefulWidget {
  const SignInForm({super.key});

  @override
  ConsumerState<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends ConsumerState<SignInForm> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    final email = _email.text.trim();
    final password = _password.text;
    if (email.isEmpty || password.isEmpty) {
      NotificationUtils.error(context, 'Email and password are required.');
      return;
    }
    try {
      await ref
          .read(authenticationProvider.notifier)
          .login(email, password, ref.read(rememberMeProvider));
    } catch (error) {
      if (!mounted) return;
      final message = error is AppException
          ? error.message
          : 'Unable to sign in. Check your details and try again.';
      NotificationUtils.error(context, message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final authState = ref.watch(authenticationProvider);
    final rememberMe = ref.watch(rememberMeProvider);

    ref.listen(authenticationProvider, (prev, next) {
      next.whenOrNull(
        data: (data) {
          if (data.state != AuthMode.authenticated) return;
          NotificationUtils.info(context, 'Signed in successfully.');
        },
      );
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 44,
          width: MediaQuery.of(context).size.width,
          child: ZintraTextField(
            label: 'Email',
            hint: 'Enter your email',
            controller: _email,
            keyboardType: TextInputType.emailAddress,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 44,
          width: MediaQuery.of(context).size.width,
          child: ZintraTextField(
            label: 'Password',
            hint: 'Enter your password',
            controller: _password,
            obscureText: true,
          ),
        ),
        InkWell(
          onTap: () =>
              ref.read(rememberMeProvider.notifier).state = !rememberMe,
          child: Row(
            children: [
              Checkbox(
                value: rememberMe,
                onChanged: (value) =>
                    ref.read(rememberMeProvider.notifier).state =
                        value ?? false,
                activeColor: colorScheme.primary,
                checkColor: colorScheme.surface,
              ),
              Text(
                'Remember Me',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: authState.isLoading ? null : _signIn,
          style: ButtonStyle(
            padding: const WidgetStatePropertyAll(EdgeInsets.zero),
            fixedSize: WidgetStatePropertyAll(
              Size(MediaQuery.of(context).size.width, 36),
            ),
            backgroundColor: WidgetStatePropertyAll(colorScheme.primary),
            shape: const WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            ),
          ),
          child: authState.isLoading
              ? const CircularProgressIndicator()
              : const Text(
                  'Sign In',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ZintraColorPrimitives.white,
                  ),
                ),
        ),
      ],
    );
  }
}
