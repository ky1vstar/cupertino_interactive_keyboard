import 'package:cupertino_interactive_keyboard_example/catalog.dart';
import 'package:cupertino_interactive_keyboard_example/input_accessory.dart';
import 'package:cupertino_interactive_keyboard_example/nested_navigation.dart';
import 'package:cupertino_interactive_keyboard_example/simple_scroll_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/": (context) => const Catalog(),
        "/simple_scroll_view": (context) => const SimpleScrollView(),
        "/input_accessory": (context) => const InputAccessory(),
        "/nested_navigation": (context) => const NestedNavigation(),
      },
    );
  }
}
