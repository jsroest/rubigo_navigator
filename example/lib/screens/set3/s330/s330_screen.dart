import 'package:example/widgets/app_bar_title.dart';
import 'package:flutter/material.dart';

class S330Screen extends StatelessWidget {
  const S330Screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(
          title: 'S330',
          subTitle: 'This screen uses no mixins',
        ),
      ),
      body: Container(),
    );
  }
}
