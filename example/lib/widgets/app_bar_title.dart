import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({
    required this.title,
    required this.breadCrumbsNotifier,
    super.key,
  });

  final String title;
  final ValueListenable<String> breadCrumbsNotifier;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Screen: $title'),
        ValueListenableBuilder(
          valueListenable: breadCrumbsNotifier,
          builder: (context, value, child) => Text(breadCrumbsNotifier.value),
        ),
      ],
    );
  }
}
