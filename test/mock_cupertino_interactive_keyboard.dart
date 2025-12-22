import 'dart:ui';

import 'package:cupertino_interactive_keyboard/cupertino_interactive_keyboard_platform_interface.dart';

class MockCupertinoInteractiveKeyboard extends CupertinoInteractiveKeyboardPlatform {
  final scrollableRects = <int, Rect>{};
  final inputAccessoryHeights = <int, double>{};

  @override
  Future<bool?> initialize({required bool firstTime}) {
    if (firstTime) {
      scrollableRects.clear();
      inputAccessoryHeights.clear();
    }
    return Future.value(true);
  }

  @override
  Future<void> setScrollableRect(int id, Rect rect) {
    scrollableRects[id] = rect;
    return Future.value();
  }

  @override
  Future<void> removeScrollableRect(int id) {
    scrollableRects.remove(id);
    return Future.value();
  }

  @override
  Future<void> setInputAccessoryHeight(int id, double height) {
    inputAccessoryHeights[id] = height;
    return Future.value();
  }

  @override
  Future<void> removeInputAccessoryHeight(int id) {
    inputAccessoryHeights.remove(id);
    return Future.value();
  }
}