import 'package:cupertino_interactive_keyboard/cupertino_interactive_keyboard_platform_interface.dart';
import 'package:cupertino_interactive_keyboard/src/current_route_aware.dart';
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

class _IOSCupertinoInputAccessory extends State<IOSCupertinoInputAccessory>
    with CurrentRouteAware {
  final _viewId = _nextViewId++;
  double? _latestHeight;

  @override
  void dispose() {
    super.dispose();
    CupertinoInteractiveKeyboardPlatform.instance
        .removeInputAccessoryHeight(_viewId);
  }

  @override
  void didChangeRouteCurrentState() {
    super.didChangeRouteCurrentState();
    _reportHeight();
  }

  @override
  Widget build(BuildContext context) {
    return HeightObserver(
      onChange: (height) {
        _latestHeight = height;
        _reportHeight();
      },
      child: widget.child,
    );
  }

  void _reportHeight() {
    if (!isRouteCurrent) {
      CupertinoInteractiveKeyboardPlatform.instance
          .removeInputAccessoryHeight(_viewId);
    } else if (_latestHeight != null) {
      CupertinoInteractiveKeyboardPlatform.instance
          .setInputAccessoryHeight(_viewId, _latestHeight!);
    }
  }
}
