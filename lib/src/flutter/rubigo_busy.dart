import 'package:flutter/material.dart';

class RubigoBusy extends StatelessWidget {
  const RubigoBusy({
    required this.child,
    required this.enabled,
    required this.isBusy,
    required this.showProgressIndicator,
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
  final bool enabled;
  final bool isBusy;
  final bool showProgressIndicator;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IgnorePointer(
          ignoring: enabled && isBusy,
          child: child,
        ),
        if (enabled &&
            isBusy &&
            showProgressIndicator &&
            (progressIndicator == null))
          const Center(
            child: CircularProgressIndicator(),
          ),
        if (enabled &&
            isBusy &&
            showProgressIndicator &&
            (progressIndicator != null))
          progressIndicator!,
      ],
    );
  }
}
