import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class YearsPage extends HookConsumerWidget {
  const YearsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("YearsPage"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("This is YearsPage"),
          ],
        ),
      ),
    );
  }
}
