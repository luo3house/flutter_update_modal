dynamic Function() withThrottle(
  dynamic Function() callback, [
  Duration duration = const Duration(milliseconds: 800),
]) {
  var lastTriggerAt = 0;
  return () {
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - lastTriggerAt > duration.inMilliseconds) {
      lastTriggerAt = now;
      callback();
    }
  };
}
