import 'package:cupertino_interactive_keyboard/src/cupertino_interactive_keyboard_platform_interface.dart';
import 'package:cupertino_interactive_keyboard/src/current_route_aware.dart';
import 'package:cupertino_interactive_keyboard/src/interactive_keyboard_scroll_physics.dart';
import 'package:cupertino_interactive_keyboard/src/rect_observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

var _firstTime = true;
var _nextViewId = 0;

class CupertinoInteractiveKeyboard extends StatelessWidget {
  const CupertinoInteractiveKeyboard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return IOSCupertinoInteractiveKeyboard(child: child);
    } else {
      return child;
    }
  }
}

class IOSCupertinoInteractiveKeyboard extends StatefulWidget {
  const IOSCupertinoInteractiveKeyboard({super.key, required this.child});

  final Widget child;

  @override
  State<StatefulWidget> createState() =>
      _IOSCupertinoInteractiveKeyboardState();
}

class _IOSCupertinoInteractiveKeyboardState
    extends State<IOSCupertinoInteractiveKeyboard> with CurrentRouteAware {
  final _viewId = _nextViewId++;
  Rect? _latestRect;

  @override
  void initState() {
    super.initState();
    CupertinoInteractiveKeyboardPlatform.instance
        .initialize(firstTime: _firstTime);
    _firstTime = false;
  }

  @override
  void dispose() {
    super.dispose();
    CupertinoInteractiveKeyboardPlatform.instance.removeScrollableRect(_viewId);
  }

  @override
  void didChangeRouteCurrentState() {
    super.didChangeRouteCurrentState();
    _reportRect();
  }

  @override
  Widget build(BuildContext context) {
    final scrollBehavior = ScrollConfiguration.of(context);
    final newScrollPhysics = const InteractiveKeyboardScrollPhysics().applyTo(
      scrollBehavior.getScrollPhysics(context),
    );
    final newScrollBehavior =
        scrollBehavior.copyWith(physics: newScrollPhysics);

    return ScrollConfiguration(
      behavior: newScrollBehavior,
      child: RectObserver(
        onChange: (rect) {
          _latestRect = rect;
          _reportRect();
        },
        child: widget.child,
      ),
    );
  }

  void _reportRect() {
    if (!isRouteCurrent) {
      CupertinoInteractiveKeyboardPlatform.instance
          .removeScrollableRect(_viewId);
    } else if (_latestRect != null) {
      CupertinoInteractiveKeyboardPlatform.instance
          .setScrollableRect(_viewId, _latestRect!);
    }
  }
}
