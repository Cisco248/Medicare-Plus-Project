import 'package:app/core/components/button.dart';
import 'package:app/core/components/divider.dart';
import 'package:app/core/components/textfield.dart';
import 'package:app/core/themes/primitives/colors.dart';
import 'package:app/core/themes/primitives/fonts.dart';
import 'package:app/data/services/user_service.dart';
import 'package:app/presentation/auth/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(authFormProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Appbar"),
        automaticallyImplyActions: false,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 32.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            spacing: 8,
            children: [
              LoginTopSection(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                spacing: 8.0,
                children: [
                  ZintraButton(
                    onPressed: () {
                      ref.read(authFormProvider.notifier).state =
                          AuthFormMode.signIn;
                    },
                    label: "Login",
                    variant: mode == AuthFormMode.signIn
                        ? ZintraButtonVariant.outline
                        : ZintraButtonVariant.ghost,
                  ),
                  ZintraButton(
                    onPressed: () {
                      ref.read(authFormProvider.notifier).state =
                          AuthFormMode.signUp;
                    },
                    label: 'Register',
                    variant: mode == AuthFormMode.signUp
                        ? ZintraButtonVariant.outline
                        : ZintraButtonVariant.ghost,
                  ),
                ],
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: mode == AuthFormMode.signIn
                    ? SignInForm(key: ValueKey('signin'))
                    : SignUpForm(key: ValueKey('signup')),
              ),
              LoginBottomSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginTopSection extends StatelessWidget {
  const LoginTopSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.only(top: 8, bottom: 32),
      child: Center(
        child: Text('Medicare Plus', style: ZintraTypography.h1Bold),
      ),
    );
  }
}

class LoginBottomSection extends StatelessWidget {
  const LoginBottomSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.only(),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 16,
          children: [
            ZintraDivider(),
            Text(
              'Sign using Social Accounts',
              style: ZintraTypography.h6Medium,
            ),
            Row(
              spacing: 8,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.google),
                  onPressed: () {},
                ),
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.apple),
                  onPressed: () {},
                ),
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.facebook),
                  onPressed: () {},
                ),
                IconButton(icon: FaIcon(FontAwesomeIcons.x), onPressed: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SignInForm extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignInForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      spacing: 8,
      children: [
        ZintraTextField(label: "Email", controller: emailController),
        ZintraTextField(
          label: "Password",
          controller: passwordController,
          obscureText: true,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          spacing: 4,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Checkbox(value: false, onChanged: (value) {}),
                Text('Remember Me', style: ZintraTypography.bodyLargeMedium),
              ],
            ),
          ],
        ),
        ZintraButton(onPressed: () => signInService(context), label: 'Sign In'),
      ],
    );
  }

  void signInService(BuildContext context) async {
    final email = emailController.text;
    final password = passwordController.text;

    try {
      if (email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Field are Empty',
              style: TextStyle(
                color: ZintraColorPrimitives.black,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            backgroundColor: ZintraColorPrimitives.destructive100,
          ),
        );
        return;
      }

      final res = await UserService.loginService(email, password);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              res,
              style: TextStyle(
                color: ZintraColorPrimitives.black,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            backgroundColor: ZintraColorPrimitives.success100,
          ),
        );
      }
      if (context.mounted) Navigator.pushNamed(context, '/dashboard');
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: $e',
              style: TextStyle(
                color: ZintraColorPrimitives.black,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            backgroundColor: ZintraColorPrimitives.destructive100,
          ),
        );
        Navigator.pushNamed(context, '/auth');
      }
    }
  }
}

class SignUpForm extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      spacing: 8,
      children: [
        ZintraTextField(label: "Full Name", controller: nameController),
        ZintraTextField(label: "Email", controller: emailController),
        ZintraTextField(label: "Mobile Number", controller: mobileController),
        ZintraTextField(label: "Password", controller: passwordController),
        Padding(
          padding: EdgeInsetsGeometry.symmetric(vertical: 16),
          child: ZintraButton(
            label: 'Sign Up',
            onPressed: () => signUpService(context),
            variant: ZintraButtonVariant.primary,
          ),
        ),
      ],
    );
  }

  void signUpService(BuildContext context) async {
    final name = nameController.text;
    final email = emailController.text;
    final mobile = mobileController.text;
    final password = passwordController.text;

    try {
      if (email.isEmpty || password.isEmpty || name.isEmpty || mobile.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Field are Empty',
              style: TextStyle(
                color: ZintraColorPrimitives.black,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            backgroundColor: ZintraColorPrimitives.destructive100,
          ),
        );
        return;
      }

      final res = await UserService.registerService(
        name,
        email,
        mobile,
        password,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              res,
              style: TextStyle(
                color: ZintraColorPrimitives.black,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            backgroundColor: ZintraColorPrimitives.success100,
          ),
        );
      }
      if (context.mounted) Navigator.pushNamed(context, '/auth');
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: $e',
              style: TextStyle(
                color: ZintraColorPrimitives.black,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            backgroundColor: ZintraColorPrimitives.destructive100,
          ),
        );
      }
      if (context.mounted) Navigator.pushNamed(context, '/auth');
    }
  }
}
