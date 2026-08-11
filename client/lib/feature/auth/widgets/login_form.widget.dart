import 'package:client/core/themes/primitives/colors.dart';
import 'package:client/core/utils/notification.utils.dart';
import 'package:client/core/widgets/textfield.widget.dart';
import 'package:client/feature/auth/notifiers/authentication.notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final rememberMeProvider = StateProvider<bool>((ref) => false);

class SignInForm extends ConsumerWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignInForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final authState = ref.watch(authenticationProvider);
    final rememberMe = ref.watch(rememberMeProvider);

    void signInService() {
      final email = emailController.text;
      final password = passwordController.text;
      if (email.isEmpty || password.isEmpty) {
        return NotificationUtils.error(context, 'Field are Empty');
      }
      ref
          .read(authenticationProvider.notifier)
          .login(email, password, rememberMe);
    }

    ref.listen(authenticationProvider, (prev, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          final message = error.toString().replaceAll('Exception: ', '');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: Colors.red),
          );
        },
        data: (data) {
          final message = 'Logging Successfully!';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: Colors.green),
          );
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
            label: "Email",
            hint: 'Enter your email',
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
          ),
        ),
        SizedBox(height: 8),
        SizedBox(
          height: 44,
          width: MediaQuery.of(context).size.width,
          child: ZintraTextField(
            label: "Password",
            hint: 'Enter your password',
            controller: passwordController,
            obscureText: true,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          spacing: 4,
          children: [
            InkWell(
              onTap: () =>
                  ref.read(rememberMeProvider.notifier).state = !rememberMe,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
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
          ],
        ),
        ElevatedButton(
          onPressed: authState.isLoading ? null : () => signInService(),
          style: ButtonStyle(
            padding: WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            ),
            fixedSize: WidgetStatePropertyAll(
              Size(MediaQuery.of(context).size.width, 36),
            ),
            backgroundColor: WidgetStatePropertyAll(colorScheme.primary),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            ),
          ),
          child: authState.isLoading
              ? CircularProgressIndicator()
              : Text(
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
