import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({
    required this.title,
    required this.breadCrumbs,
    super.key,
  });

  final String title;
  final ValueListenable<String> breadCrumbs;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Screen: $title'),
        ValueListenableBuilder(
          valueListenable: breadCrumbs,
          builder: (context, value, child) => Text(breadCrumbs.value),
        ),
      ],
    );
  }
}
