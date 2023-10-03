import 'package:cupertino_interactive_keyboard/cupertino_interactive_keyboard_platform_interface.dart';
import 'package:cupertino_interactive_keyboard/src/height_observer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

var _nextViewId = 0;

class CupertinoInputAccessory extends StatelessWidget {
  const CupertinoInputAccessory({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return IOSCupertinoInputAccessory(child: child);
    } else {
      return child;
    }
  }
}

class IOSCupertinoInputAccessory extends StatefulWidget {
  const IOSCupertinoInputAccessory({super.key, required this.child});

  final Widget child;

  @override
  State<StatefulWidget> createState() => _IOSCupertinoInputAccessory();
}

class _IOSCupertinoInputAccessory extends State<IOSCupertinoInputAccessory> {
  final _viewId = _nextViewId++;

  @override
  void dispose() {
    super.dispose();
    CupertinoInteractiveKeyboardPlatform.instance
        .removeInputAccessoryHeight(_viewId);
  }

  @override
  Widget build(BuildContext context) {
    return HeightObserver(
      onChange: (height) => CupertinoInteractiveKeyboardPlatform.instance
          .setInputAccessoryHeight(_viewId, height),
      child: widget.child,
    );
  }
}
