import 'dart:io';

import 'package:cupertino_interactive_keyboard/src/cupertino_interactive_keyboard_platform_interface.dart';
import 'package:cupertino_interactive_keyboard/src/rect_observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
    extends State<IOSCupertinoInteractiveKeyboard> {
  final _viewId = _nextViewId++;

  @override
  void initState() {
    super.initState();
    CupertinoInteractiveKeyboardPlatform.instance.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    CupertinoInteractiveKeyboardPlatform.instance.removeScrollableRect(_viewId);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print(
        "keklol ModalRoute.of(context).isActive ${ModalRoute.of(context)?.isActive}");
  }

  @override
  Widget build(BuildContext context) {
    return RectObserver(
      onChange: (rect) => CupertinoInteractiveKeyboardPlatform.instance
          .setScrollableRect(_viewId, rect),
      child: widget.child,
    );
  }
}
