import 'package:example/screens/screens.dart';
import 'package:example/widgets/app_bar_title.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S140Screen extends StatelessWidget {
  const S140Screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: rubigoBackButton(context, holder.get<RubigoRouter>()),
        title: const AppBarTitle(
          title: 'S140',
          subTitle: 'This screen uses no mixins',
        ),
      ),
      body: Container(),
    );
  }
}
