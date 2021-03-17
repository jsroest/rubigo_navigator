// @dart=2.9

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rubigo_navigator/services/rubigo_busy_service.dart';

class Busy extends StatelessWidget {
  Busy({
    Key key,
    @required this.child,
    this.progressIndicator,
    this.opacityWithoutProgressIndicator = 0.0,
    this.opacityWithProgressIndicator = 0.3,
    this.barrierColor = Colors.grey,
  }) : super(key: key);

  final Widget child;
  final Widget progressIndicator;
  final double opacityWithoutProgressIndicator;
  final double opacityWithProgressIndicator;
  final Color barrierColor;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, _) {
        var busyService = watch(busyServiceProvider);
        return Stack(
          children: [
            IgnorePointer(
              ignoring: busyService.enabled && busyService.isBusy,
              child: child,
            ),
            if (busyService.enabled &&
                busyService.isBusy &&
                busyService.showProgressIndicator &&
                (progressIndicator == null))
              Center(
                child: CircularProgressIndicator(),
              ),
            if (busyService.enabled &&
                busyService.isBusy &&
                busyService.showProgressIndicator &&
                (progressIndicator != null))
              progressIndicator,
          ],
        );
      },
    );
  }
}
