import 'package:flutter/widgets.dart';

class InteractiveKeyboardScrollPhysics extends ScrollPhysics {
  const InteractiveKeyboardScrollPhysics({super.parent});

  @override
  InteractiveKeyboardScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return InteractiveKeyboardScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double adjustPositionForNewDimensions({
    required ScrollMetrics oldPosition,
    required ScrollMetrics newPosition,
    required bool isScrolling,
    required double velocity,
  }) {
    if (isScrolling &&
        newPosition.axisDirection == AxisDirection.up &&
        oldPosition.viewportDimension != newPosition.viewportDimension) {
      return oldPosition.pixels;
    } else {
      return super.adjustPositionForNewDimensions(
        oldPosition: oldPosition,
        newPosition: newPosition,
        isScrolling: isScrolling,
        velocity: velocity,
      );
    }
  }
}
