import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef OnWidgetRectChange = void Function(Rect rect);

class RectObserver extends SingleChildRenderObjectWidget {
  const RectObserver({
    super.key,
    required this.onChange,
    required Widget super.child,
  });

  final OnWidgetRectChange onChange;

  @override
  RectObserverRenderObject createRenderObject(BuildContext context) =>
      RectObserverRenderObject(onChange);

  @override
  void updateRenderObject(
    BuildContext context,
    RectObserverRenderObject renderObject,
  ) {
    renderObject.onChange = onChange;
  }
}

class RectObserverRenderObject extends RenderProxyBox {
  RectObserverRenderObject(this.onChange);

  Rect? oldRect;
  OnWidgetRectChange onChange;

  @override
  void performLayout() {
    super.performLayout();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final newOffset = child!.localToGlobal(Offset.zero);
      final newSize = child!.size;
      final newRect = Rect.fromLTWH(
        newOffset.dx,
        newOffset.dy,
        newSize.width,
        newSize.height,
      );

      if (newRect != oldRect) {
        oldRect = newRect;
        onChange(newRect);
      }
    });
  }
}
