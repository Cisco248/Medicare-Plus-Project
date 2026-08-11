import 'package:client/core/themes/primitives/colors.dart';
import 'package:client/core/utils/notification.utils.dart';
import 'package:client/core/widgets/textfield.widget.dart';
import 'package:client/feature/auth/models/user_model.dart';
import 'package:client/feature/auth/notifiers/authentication.notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpForm extends ConsumerWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignUpForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void signUpService() async {
      final name = nameController.text;
      final email = emailController.text;
      final mobile = mobileController.text;
      final password = passwordController.text;
      try {
        if (email.isEmpty ||
            password.isEmpty ||
            name.isEmpty ||
            mobile.isEmpty) {
          NotificationUtils.error(context, 'Field are Empty');
          return;
        }
        final userData = UserModel(
          name: name,
          email: email,
          mobnum: mobile,
          password: password,
        );
        debugPrint(userData.toString());
        ref.read(authenticationProvider.notifier).register(userData);
      } catch (e) {
        NotificationUtils.error(context, 'Error: $e');
      }
    }

    final authState = ref.watch(authenticationProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      spacing: 8,
      children: [
        SizedBox(
          height: 44,
          width: MediaQuery.of(context).size.width,
          child: ZintraTextField(
            label: "Full Name",
            controller: nameController,
          ),
        ),
        SizedBox(
          height: 44,
          width: MediaQuery.of(context).size.width,
          child: ZintraTextField(label: "Email", controller: emailController),
        ),
        SizedBox(
          height: 44,
          width: MediaQuery.of(context).size.width,
          child: ZintraTextField(
            label: "Mobile Number",
            controller: mobileController,
          ),
        ),
        SizedBox(
          height: 44,
          width: MediaQuery.of(context).size.width,
          child: ZintraTextField(
            label: "Password",
            controller: passwordController,
            obscureText: true,
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: authState.isLoading ? null : () => signUpService(),
          style: ButtonStyle(
            fixedSize: WidgetStatePropertyAll(
              Size(MediaQuery.of(context).size.width, 48),
            ),
            backgroundColor: WidgetStatePropertyAll(colorScheme.primary),
          ),
          child: authState.isLoading
              ? CircularProgressIndicator()
              : Text(
                  'Sign Up',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: ZintraColorPrimitives.white,
                  ),
                ),
        ),
      ],
    );
  }
}
