import 'package:client/core/widgets/avatar.widget.dart';
import 'package:client/core/widgets/card.widget.dart';
import 'package:client/feature/auth/notifiers/authentication.notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PatientCard extends ConsumerWidget {
  final String name;
  final int age;
  final Map<String, dynamic>? data;

  const PatientCard({
    super.key,
    this.name = 'Mark Anton',
    this.age = 45,
    this.data = const {"bp": '120/80', "hp": 82},
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).colorScheme;
    final userData = ref.watch(authenticationProvider);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: theme.primaryFixedDim,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(64),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: userData.when(
        data: (user) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            ZintraAvatar(size: 96, initials: user.data?.name[0] ?? ''),
            ZintraCard(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${user.data?.name}",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Email: ${user.data?.email}',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  // Row(
                  //   children: [
                  //     Text(
                  //       'BP: ${data!['bp']} mmHg',
                  //       style: TextStyle(
                  //         fontFamily: 'Inter',
                  //         fontSize: 10,
                  //         fontWeight: FontWeight.w300,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // Row(
                  //   children: [
                  //     Text(
                  //       'HR: ${data!['hp']} bpm',
                  //       style: TextStyle(
                  //         fontFamily: 'Inter',
                  //         fontSize: 10,
                  //         fontWeight: FontWeight.w300,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
        error: (e, _) => Center(child: Text(e.toString())),
        loading: () => Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
