import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

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
