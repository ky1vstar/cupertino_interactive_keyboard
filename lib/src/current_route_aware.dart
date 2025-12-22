import 'package:flutter/widgets.dart';

mixin CurrentRouteAware<T extends StatefulWidget> on State<T> {
  bool get isRouteCurrent => _isRouteCurrent;
  var _isRouteCurrent = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isRouteCurrent =
        (ModalRoute.isCurrentOf(context) ?? true) && TickerMode.of(context);
    if (_isRouteCurrent != isRouteCurrent) {
      _isRouteCurrent = isRouteCurrent;
      didChangeRouteCurrentState();
    }
  }

  @mustCallSuper
  void didChangeRouteCurrentState() {}
}
