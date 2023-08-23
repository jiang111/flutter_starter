import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CRefreshIndicator extends StatefulWidget {
  final Widget child;
  final AsyncCallback onRefresh;
  final bool enablePullDown;

  const CRefreshIndicator({
    Key? key,
    required this.child,
    this.enablePullDown = true,
    required this.onRefresh,
  }) : super(key: key);

  @override
  State createState() => _CRefreshIndicatorState();
}

class _CRefreshIndicatorState extends State<CRefreshIndicator> with SingleTickerProviderStateMixin {
  static const _indicatorSize = 50.0;

  bool _renderCompleteState = false;

  ScrollDirection prevScrollDirection = ScrollDirection.idle;

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      offsetToArmed: _indicatorSize,
      onRefresh: widget.onRefresh,
      completeStateDuration: const Duration(milliseconds: 500),
      onStateChanged: (change) {
        if (change.didChange(to: IndicatorState.complete)) {
          setState(() {
            _renderCompleteState = true;
          });
        } else if (change.didChange(to: IndicatorState.idle)) {
          setState(() {
            _renderCompleteState = false;
          });
        }
      },
      builder: (
        BuildContext context,
        Widget child,
        IndicatorController controller,
      ) {
        return Stack(
          children: <Widget>[
            AnimatedBuilder(
              animation: controller,
              builder: (BuildContext context, Widget? _) {
                if (controller.scrollingDirection == ScrollDirection.reverse &&
                    prevScrollDirection == ScrollDirection.forward) {
                  try {
                    controller.stopDrag();
                  } catch (e) {
                    print(e);
                  }
                }

                prevScrollDirection = controller.scrollingDirection;

                final containerHeight = controller.value * _indicatorSize;

                if (controller.value < 0.1) {
                  return const SizedBox.shrink();
                }
                return Container(
                  alignment: Alignment.center,
                  height: containerHeight,
                  child: OverflowBox(
                    maxHeight: _indicatorSize / 2,
                    minHeight: _indicatorSize / 2,
                    maxWidth: _indicatorSize / 2,
                    minWidth: _indicatorSize / 2,
                    alignment: Alignment.center,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _renderCompleteState ?  const Color(0xFF13C2C2) : Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: _renderCompleteState
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: _indicatorSize / 3,
                            )
                          : SizedBox(
                              height: _indicatorSize / 2,
                              width: _indicatorSize / 2,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: const AlwaysStoppedAnimation(Colors.white),
                                value: controller.isDragging || controller.isArmed
                                    ? controller.value.clamp(0.0, 1.0)
                                    : null,
                              ),
                            ),
                    ),
                  ),
                );
              },
            ),
            AnimatedBuilder(
              builder: (context, _) {
                return Transform.translate(
                  offset: Offset(0.0, controller.value * _indicatorSize),
                  child: child,
                );
              },
              animation: controller,
            ),
          ],
        );
      },
      child: widget.child,
    );
  }
}
