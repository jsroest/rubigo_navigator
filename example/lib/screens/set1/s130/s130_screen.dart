import 'package:example/widgets/app_bar_title.dart';
import 'package:flutter/material.dart';

class S130Screen extends StatelessWidget {
  const S130Screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(
          title: 'S130',
          subTitle: 'This screen uses no mixins',
        ),
      ),
      body: Container(),
    );
  }
}
