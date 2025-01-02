import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_navigator/src/flutter/busy/rubigo_busy_event.dart';

class RubigoBusyWidget extends StatelessWidget {
  const RubigoBusyWidget({
    required this.child,
    required this.listener,
    this.progressIndicator,
    this.opacityWithoutProgressIndicator = 0.0,
    this.opacityWithProgressIndicator = 0.3,
    this.barrierColor = Colors.grey,
    super.key,
  });

  final Widget child;
  final Widget? progressIndicator;
  final double opacityWithoutProgressIndicator;
  final double opacityWithProgressIndicator;
  final Color barrierColor;
  final ValueListenable<RubigoBusyEvent> listener;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: listener,
      builder: (context, value, _) {
        return Stack(
          children: [
            IgnorePointer(
              ignoring: value.enabled && value.isBusy,
              child: child,
            ),
            if (value.enabled &&
                value.isBusy &&
                value.showProgressIndicator &&
                (progressIndicator == null))
              const Center(
                child: CircularProgressIndicator(),
              ),
            if (value.enabled &&
                value.isBusy &&
                value.showProgressIndicator &&
                (progressIndicator != null))
              progressIndicator!,
          ],
        );
      },
    );
  }
}
