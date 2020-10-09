import 'package:flutter_rubigo_navigator/navigator/rubigo_navigator.dart';

abstract class ScreenController {
  Future<void> screenOnTop(
    StackChange stackChange,
    ScreenController previousScreen,
  );

  Future<void> screenIsShown();

  Future<bool> screenIsPopping();
}
