import 'package:client/feature/auth/models/form.model.dart';
import 'package:client/feature/auth/viewmodels/form_mode.notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginTopSection extends StatelessWidget {
  const LoginTopSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.only(top: 32, bottom: 0),
      child: Consumer(
        builder: (context, ref, child) {
          final formState = ref.watch(formStateProvider);
          return Center(
            child: Column(
              children: [
                Text(
                  formState == FormStatus(state: FormMode.signIn)
                      ? 'Welcome Back'
                      : 'Welcome to',
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withAlpha(150),
                    fontFamily: 'Inter',
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
