import 'package:cupertino_interactive_keyboard/cupertino_interactive_keyboard.dart';
import 'package:flutter/material.dart';

class NestedNavigation extends StatelessWidget {
  const NestedNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nested Navigation"),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NestedNavigationSecond(),
              ),
            ),
            child: const Text("Next"),
          ),
        ],
      ),
      body: const CupertinoInteractiveKeyboard(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: SafeArea(
                minimum: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Keyboard can be dismissed interactively"),
                    TextField(
                      decoration:
                          InputDecoration(hintText: "Input something..."),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NestedNavigationSecond extends StatelessWidget {
  const NestedNavigationSecond({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nested Navigation"),
      ),
      body: const CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: SafeArea(
              minimum: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Keyboard can not be dismissed interactively"),
                  TextField(
                    decoration: InputDecoration(hintText: "Input something..."),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
