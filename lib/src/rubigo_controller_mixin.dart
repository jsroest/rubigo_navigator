import 'package:flutter/widgets.dart';
import 'package:rubigo_router/rubigo_router.dart';

/// Adds functionality to any class that is used as a 'controller' for a screen.
/// The [RubigoControllerMixin.rubigoRouter] is wired-up when [RubigoRouter.init]
/// is called
mixin RubigoControllerMixin<SCREEN_ID extends Enum> {
  /// Provides easy access to the [RubigoRouter] that is in charge of this
  /// controller.
  late RubigoRouter<SCREEN_ID> rubigoRouter;

  /// With this function, the controller is informed that this screen is now on
  /// top of the stack. It is allowed to navigate further in this function.
  Future<void> onTop(RubigoChangeInfo<SCREEN_ID> changeInfo) async {}

  /// With this function, the controller is informed that this screen is on
  /// top of the stack, and is about to be shown. It is NOT allowed to navigate
  /// further in this function.
  Future<void> willShow(RubigoChangeInfo<SCREEN_ID> changeInfo) async {}

  /// With this function, the controller is informed that this screen is on
  /// top of the stack, and is shown to the user. It is allowed to navigate
  /// further in this function, but be aware if this really is what you want.
  /// Depending on timings, it might show confusing page animations to the
  /// user.
  Future<void> isShown(RubigoChangeInfo<SCREEN_ID> changeInfo) async {}

  /// This function can be used to prevent (programmatically) back navigation in
  /// an asynchronous way, for example when you want to check with a backend, if
  /// to allow back navigation.
  /// Be aware that you might want to wire-in a [PopScope] widget to prevent
  /// back gestures, but that requires a synchronous callback. It is what it is,
  /// [See predictive-back-gesture](https://developer.android.com/guide/navigation/custom-back/predictive-back-gesture) is not compatible with asynchronous functions.
  Future<bool> mayPop() => Future.value(true);
}
