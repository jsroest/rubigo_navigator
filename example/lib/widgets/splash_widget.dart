import 'package:flutter/material.dart';

class SplashWidget extends StatelessWidget {
  const SplashWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox.expand(
        child: FittedBox(
          child: Icon(Icons.emoji_people),
        ),
      ),
    );
  }
}
