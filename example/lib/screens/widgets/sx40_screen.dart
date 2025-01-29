import 'package:example/screens/screens.dart';
import 'package:example/widgets/app_bar_title.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

class Sx040Screen extends StatelessWidget {
  const Sx040Screen({
    required this.sX40Screen,
    super.key,
  });

  final Screens sX40Screen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: rubigoBackButton(context, holder.get<RubigoRouter>()),
        title: AppBarTitle(
          title: sX40Screen.name.toUpperCase(),
          subTitle: 'This screen uses no mixins',
        ),
      ),
      body: Container(),
    );
  }
}
