import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfilePage extends HookConsumerWidget {
  const ProfilePage({super.key});

  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("This is Profile"),
            ElevatedButton(
              onPressed: () {
                //GoRouter.of(context).go("/");
                context.go("/");
              },
              child: const Text("Go to Home"),
            ),
            ElevatedButton(
              onPressed: () {
                // GoRouter.of(context).goNamed(RouteNames.dashboard);
                context.go("/profile/dashboard");
              },
              child: const Text("Go to Dashboard"),
            ),
          ],
        ),
      ),
    );
  }
}
