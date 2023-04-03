import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("this is really very awesome"),
            ElevatedButton(
              onPressed: () {
                context.go("/profile");
                // GoRouter.of(context).go("/profile");
              },
              child: const Text("Go to Profile"),
            ),
            ElevatedButton(
              onPressed: () {
                context.go("/prole");
                // GoRouter.of(context).go("/profile");
              },
              child: const Text("Go to error"),
            ),
            ElevatedButton(
              onPressed: () {
                context.go("/history");
                // GoRouter.of(context).go("/profile");
              },
              child: const Text("Go to history"),
            ),
          ],
        ),
      ),
    );
  }
}
