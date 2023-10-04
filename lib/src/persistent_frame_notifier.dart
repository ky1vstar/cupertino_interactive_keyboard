import 'package:flutter/widgets.dart';

class PersistentFrameNotifier extends ValueNotifier<Duration> {
  factory PersistentFrameNotifier() => _instance;

  PersistentFrameNotifier._() : super(Duration.zero) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // We need to add this callback on post frame because otherwise
      // Concurrent modification exception it thrown
      WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) {
        value = timeStamp;
      });
    });
  }

  static final _instance = PersistentFrameNotifier._();

  @override
  // ignore: must_call_super
  void dispose() {}
}
