import 'package:example/screens/screens.dart';
import 'package:example/widgets/app_bar_title.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S340Screen extends StatelessWidget {
  const S340Screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          leading: rubigoBackButton(context, holder.get<RubigoRouter>()),
          title: const AppBarTitle(
            title: 'S340',
            subTitle: 'This screen uses no mixins',
          ),
        ),
        body: Container(),
      ),
    );
  }
}
