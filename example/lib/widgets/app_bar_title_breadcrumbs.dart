import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

// This AppBar shows a title and the current screen stack as breadcrumbs.
class AppBarTitleBreadCrumbs<SCREEN_ID extends Enum> extends StatelessWidget {
  const AppBarTitleBreadCrumbs({
    required this.title,
    required this.screens,
    required this.notifier,
    super.key,
  });

  final String title;
  final ListOfRubigoScreens<SCREEN_ID> screens;
  final ChangeNotifier notifier;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Screen: $title'),
        ListenableBuilder(
          listenable: notifier,
          builder: (context, _) {
            return Text(
              'Screens tack: ${screens.toListOfScreenId().breadCrumbs()}',
              style: TextTheme.of(context).bodyMedium,
            );
          },
        ),
      ],
    );
  }
}
