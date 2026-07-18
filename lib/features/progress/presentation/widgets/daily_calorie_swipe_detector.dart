part of 'progress_page_body.dart';

class _DailyCalorieSwipeDetector extends StatefulWidget {
  const _DailyCalorieSwipeDetector({
    super.key,
    required this.onPreviousDay,
    required this.onNextDay,
    required this.child,
  });
  final VoidCallback onPreviousDay;
  final VoidCallback? onNextDay;
  final Widget child;
  @override
  State<_DailyCalorieSwipeDetector> createState() =>
      _DailyCalorieSwipeDetectorState();
}

class _DailyCalorieSwipeDetectorState
    extends State<_DailyCalorieSwipeDetector> {
  double _dragDistance = 0;
  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onHorizontalDragUpdate: (details) {
      _dragDistance += details.primaryDelta ?? 0;
    },
    onHorizontalDragCancel: _reset,
    onHorizontalDragEnd: (_) {
      if (_dragDistance > 48) widget.onPreviousDay();
      if (_dragDistance < -48) widget.onNextDay?.call();
      _reset();
    },
    child: widget.child,
  );
  void _reset() => _dragDistance = 0;
}
