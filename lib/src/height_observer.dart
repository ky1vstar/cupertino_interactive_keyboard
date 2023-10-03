import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef OnWidgetHeightChange = void Function(double height);

class HeightObserver extends SingleChildRenderObjectWidget {
  const HeightObserver({
    super.key,
    required this.onChange,
    required Widget super.child,
  });

  final OnWidgetHeightChange onChange;

  @override
  HeightObserverRenderObject createRenderObject(BuildContext context) =>
      HeightObserverRenderObject(onChange);

  @override
  void updateRenderObject(
    BuildContext context,
    HeightObserverRenderObject renderObject,
  ) {
    renderObject.onChange = onChange;
  }
}

class HeightObserverRenderObject extends RenderProxyBox {
  HeightObserverRenderObject(this.onChange);

  double? oldHeight;
  OnWidgetHeightChange onChange;

  @override
  void performLayout() {
    super.performLayout();

    final newHeight = child!.size.height;
    if (newHeight != oldHeight) {
      oldHeight = newHeight;
      onChange(newHeight);
    }
  }
}
