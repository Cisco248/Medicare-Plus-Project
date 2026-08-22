import 'package:client/core/widgets/appbar.widget.dart';
import 'package:client/layout/notifiers/splash.notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetStartedPage extends ConsumerWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppbarWidget(),
      backgroundColor: theme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.all(Radius.circular(32)),
                  child: Image.asset(
                    "assets/images/image_5.png",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(
                height: 196,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Text(
                    "Your Health.\nOur Care.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: theme.onSurface,
                      fontFamily: "Inter",
                      fontSize: 44,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 96,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Text(
                    "MediCare Plus helps you manage your healthcare journey with AI-powered insights, smart monitoring, digital medical records, appointments, and medication reminders.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: theme.onSurfaceVariant,
                      fontFamily: "Inter",
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                height: 48,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(theme.primary),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    await ref.read(splashProvider.notifier).onClick();
                  },
                  child: const Text(
                    "Get Started",
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 48,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Text(
                    "By continuing, you agree to our Terms of Service and Privacy Policy.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, fontFamily: "Inter"),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
