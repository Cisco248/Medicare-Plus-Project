import 'package:flutter/material.dart';

class AppLoadingPage extends StatelessWidget {
  const AppLoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App logo
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.health_and_safety_rounded,
                      size: 64,
                      color: theme.primary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "MediCare Plus",
                      style: TextStyle(
                        color: theme.primary,
                        fontFamily: "Inter",
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
