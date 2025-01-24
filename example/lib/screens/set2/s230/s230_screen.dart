import 'package:example/widgets/app_bar_title.dart';
import 'package:flutter/material.dart';

class S230Screen extends StatelessWidget {
  const S230Screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(
          title: 'S230',
          subTitle: 'This screen uses no mixins',
        ),
      ),
      body: Container(),
    );
  }
}
