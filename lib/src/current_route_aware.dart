import 'package:cupertino_interactive_keyboard/src/persistent_frame_notifier.dart';
import 'package:flutter/material.dart';

mixin CurrentRouteAware<T extends StatefulWidget> on State<T> {
  bool get isRouteCurrent => _isRouteCurrent;
  var _isRouteCurrent = false;
  ModalRoute? _currentRoute;
  final _frameNotifier = PersistentFrameNotifier();

  @override
  void initState() {
    super.initState();
    _frameNotifier.addListener(_frameCallback);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentRoute = ModalRoute.of(context);
    _frameCallback();
  }

  @override
  void dispose() {
    super.dispose();
    _frameNotifier.removeListener(_frameCallback);
    _frameNotifier.dispose();
  }

  @mustCallSuper
  void didChangeRouteCurrentState() {}

  void _frameCallback() {
    final newIsCurrent = _currentRoute?.isCurrent ?? true;
    if (_isRouteCurrent != newIsCurrent) {
      _isRouteCurrent = newIsCurrent;
      didChangeRouteCurrentState();
    }
  }
}
