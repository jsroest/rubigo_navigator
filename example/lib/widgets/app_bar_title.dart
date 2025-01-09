import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

class AppBarTitle<SCREEN_ID extends Enum> extends StatelessWidget {
  const AppBarTitle({
    required this.title,
    required this.screenStackListener,
    super.key,
  });

  final String title;
  final ValueListenable<List<SCREEN_ID>> screenStackListener;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Screen: $title'),
        ValueListenableBuilder(
          valueListenable: screenStackListener,
          builder: (context, value, child) =>
              Text(screenStackListener.value.breadCrumbs()),
        ),
      ],
    );
  }
}
