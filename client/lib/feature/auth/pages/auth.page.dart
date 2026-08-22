import 'package:client/core/widgets/appbar.widget.dart';
import 'package:client/feature/auth/models/auth.state.dart';
import 'package:client/feature/auth/notifiers/form_mode.notifier.dart';
import 'package:client/feature/auth/widgets/bottom.widget.dart';
import 'package:client/feature/auth/widgets/login_form.widget.dart';
import 'package:client/feature/auth/widgets/register_form.widget.dart';
import 'package:client/feature/auth/widgets/top.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(formStateProvider);
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppbarWidget(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      SizedBox(height: size.height * 0.016),
                      const LoginTopSection(),
                      SizedBox(height: size.height * 0.016),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () => ref
                                      .read(formStateProvider.notifier)
                                      .toggle(),
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                      formState.state == FormMode.signIn
                                          ? colorScheme.primary
                                          : Colors.transparent,
                                    ),
                                    side: WidgetStatePropertyAll(
                                      BorderSide(color: colorScheme.primary),
                                    ),
                                    fixedSize: WidgetStatePropertyAll(
                                      Size(120, 40),
                                    ),
                                  ),
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                      color: formState.state == FormMode.signIn
                                          ? colorScheme.surface
                                          : colorScheme.primary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                TextButton(
                                  onPressed: () => ref
                                      .read(formStateProvider.notifier)
                                      .toggle(),
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                      formState.state == FormMode.signUp
                                          ? colorScheme.primary
                                          : Colors.transparent,
                                    ),
                                    side: WidgetStatePropertyAll(
                                      BorderSide(color: colorScheme.primary),
                                    ),
                                    fixedSize: WidgetStatePropertyAll(
                                      Size(120, 40),
                                    ),
                                  ),
                                  child: Text(
                                    "Register",
                                    style: TextStyle(
                                      color: formState.state == FormMode.signUp
                                          ? colorScheme.surface
                                          : colorScheme.primary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.032,
                            ),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              child: formState.state == FormMode.signIn
                                  ? SignInForm(key: ValueKey("signin"))
                                  : SignUpForm(key: ValueKey("signup")),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      const LoginBottomSection(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
