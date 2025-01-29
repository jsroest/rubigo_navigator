import 'package:example/screens/screens.dart';
import 'package:example/screens/widgets/sx40_screen.dart';
import 'package:flutter/material.dart';

class S140Screen extends StatelessWidget {
  const S140Screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Sx040Screen(
      sX40Screen: Screens.s140,
    );
  }
}
