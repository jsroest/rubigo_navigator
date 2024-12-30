import 'package:example/screens/splash_screen/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_navigator/rubigo_navigator.dart';

class SplashScreen extends StatelessWidget
    with RubigoScreenMixin<SplashController> {
  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.purple,
    );
  }
}
