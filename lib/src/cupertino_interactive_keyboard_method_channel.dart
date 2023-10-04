import 'package:cupertino_interactive_keyboard/cupertino_interactive_keyboard_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// An implementation of [CupertinoInteractiveKeyboardPlatform] that uses method channels.
class MethodChannelCupertinoInteractiveKeyboard
    extends CupertinoInteractiveKeyboardPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('cupertino_interactive_keyboard');

  @override
  Future<bool?> initialize({required bool firstTime}) async {
    return methodChannel.invokeMethod<bool>('initialize', {
      'firstTime': firstTime,
    });
  }

  @override
  Future<void> setScrollableRect(int id, Rect rect) {
    return methodChannel.invokeMethod('setScrollableRect', {
      'id': id,
      'rect': {
        'x': rect.left,
        'y': rect.top,
        'width': rect.width,
        'height': rect.height,
      },
    });
  }

  @override
  Future<void> removeScrollableRect(int id) {
    return methodChannel.invokeMethod('removeScrollableRect', {
      'id': id,
    });
  }

  @override
  Future<void> setInputAccessoryHeight(int id, double height) {
    return methodChannel.invokeMethod('setInputAccessoryHeight', {
      'id': id,
      'height': height,
    });
  }

  @override
  Future<void> removeInputAccessoryHeight(int id) {
    return methodChannel.invokeMethod('removeInputAccessoryHeight', {
      'id': id,
    });
  }
}
