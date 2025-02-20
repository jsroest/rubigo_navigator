****
<!--  
This README describes the package. If you publish this package to pub.dev,  
this README's contents appear on the landing page for your package.  
  
For information about how to write a good package README, see the guide for  
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).  
  
For general information about developing packages, see the Dart guide for  
[creating packages](https://dart.dev/guides/libraries/create-packages)  
and the Flutter guide for  
[developing packages and plugins](https://flutter.dev/to/develop-packages).  
-->  

## Introduction

RubigoRouter is a simple to use, minimalistic router for Flutter projects.

In kind of a way it is Navigator 1.0 **with** direct access to the screen stack.

It can also add navigation events to the controller. With these events, the controller can act on
and influence navigation while it happens.

Managing the stack was never easier.™ 🥳 🚀

## Features

### Perform navigation

* **push**  
  Push a specific screen on the stack.
* **pop**  
  Pop the topmost screen from the stack.
* **popTo**  
  Pop directly to a specific screen.
* **replaceStack**  
  Replace the stack with a new stack.
* **remove**  
  Silently remove a screen from the stack.

### Adds coding convenience

* From your **screen widget**, you have **direct access** to the corresponding **controller**.
* From your **controller**, you have direct access to the ```RubigoRouter``` and other cool stuff (
  like the Flutter's ```Navigator```, a busyService and the current screen stack).

### Act on navigation events

#### Each controller that has the `RubigoControllerMixin` is informed about the following navigation events:

* **onTop(changeInfo)**  
  This event is called when the screen is on top of the stack.  
  Further navigation **is** allowed.
* **willShow(changeInfo)**  
  This event is called when the screen is on top of the stack and **will** be shown.  
  Further navigation **is not** allowed.
* **bool mayPop()**  
  This event is called when the screen is about to be popped from the stack.  
  If you return ```false```, the pop is cancelled.  
  Further navigation **is not** allowed.
* **removedFromStack()**  
  This event is called when the screen is removed from the stack.
  Further navigation **is not** allowed.

#### **changeInfo** contains the following data:

* **eventType:**  
  The event type can be push, pop, popTo or replaceStack.
* **previousScreen:**  
  This is the screen where we are coming from.
* **screenStack:**  
  This is a copy of the current screen stack.

With this information, the controller can decide what to do next, like navigate further or load data from
an asynchronous source.

#### Typical use cases

* **onTop()**  
  Navigate to other screens without the user noticing it.
* **willShow()**  
  Get data from an asynchronous source, like a local database. The navigation to this screen with the corresponding animation will start as soon as this event returns.

### Know when the app is busy and absorb touch events

This is not mandatory to use, but it is a nice addition, especially for Line of Business apps.

The ```RubigoRouter``` holds a ```RubigoBusyService```. Whenever navigation is in progress, or when
the app executes some code in a ```busyWrapper```, the app marks itself as **busy**.

When the app is **busy** and the ```RubigoBusyWidget``` is used, all touch events are absorbed. This
protects your app in a simple and easy to reason about way.

## Getting started

At the time of writing, this package requires:

* dart sdk: 3.0.0 or greater
* flutter version 3.10.0 or greater

### Setting up the app

Create an enum to uniquely identify each an every screen.

```dart
enum Screens {
  splashScreen,
  s100,
  s200,
}
```

Create a list that combines the enum, with a widget and a controller.

```dart
// holder = your favorite service locator and/or dependency injection package.
// It's important that the controllers are registered as singletons.
final ListOfRubigoScreens<Screens> availableScreens = [
  RubigoScreen(
    Screens.splashScreen,
    SplashScreen(),
    () => holder.get(SplashController.new),
  ),
  RubigoScreen(
    Screens.s100,
    S100Screen(),
    () => holder.get(S100Controller.new),
  ),
  RubigoScreen(
    Screens.s200,
    S200Screen(),
    () => holder.get(S200Controller.new),
  ),
];
```

Create a `RubigoRouter` and pass the `availableScreens` and the splash screen id.

```dart

final rubigoRouter = RubigoRouter<Screens>(
  availableScreens: availableScreens,
  splashScreenId: Screens.splashScreen,
);
```

Create a `RubigoRouterDelegate`, and pass it the `rubigoRouter`.

```dart
final routerDelegate = RubigoRouterDelegate(
  rubigoRouter: rubigoRouter,
);
```

Create a function that holds your initialization code and that returns the first screen.

```dart
Future<Screens> initAndGetFirstScreen() async {
  //Initialize your app here.
  //Create objects with your favorite dependency injection framework
  //and store them in your favorite service locator.
  return Screens.s100;
}
```

Create a `RubigoMaterialApp` and pass
- a `initAndGetFirstScreen` function
- a `routerDelegate`
- a `RubigoRootBackButtonDispatcher`

```dart
RubigoMaterialApp(
  initAndGetFirstScreen: initAndGetFirstScreen,
  routerDelegate: routerDelegate,
  backButtonDispatcher: RubigoRootBackButtonDispatcher(rubigoRouter),
),
```

### Setting up screens

You can use any widget as a screen widget.

If you add the `RubigoScreenMixin`, you can access the controller of your page directly in your
code. This controller is wired up during the initialization phase.

### Example usage

```dart
ElevatedButton(
  onPressed: controller.onS200ButtonPressed,
  child: const Text('Push S200'),
)
```

### Setting up controllers

You can use any class as a controller for your screen.

If you add the `RubigoControllerMixin`, you can access the router of you app directly in your code.
The router is wired up during the initialization phase.

#### Navigation events

Each controller with the `RubigoControllerMixin` gets access to the following navigation events:

```dart
@override
Future<void> onTop(RubigoChangeInfo<Screens> changeInfo) async {}

@override
Future<void> willShow(RubigoChangeInfo<Screens> changeInfo) async {}

@override
Future<bool> mayPop() => Future.value(true);

@override
Future<void> removedFromStack() async {}
```

The `onTop` event allows further navigation. When the screen stack is stable Flutter
framework is informed about the new state of the screen stack. This will result in a single page
transition, from the old screen to the new screen.

The application logic can use the data provided in the `RubigoChangeInfo` to decide what to do next.

```dart
enum EventType {
  push,
  pop,
  popTo,
  replaceStack,
}

class RubigoChangeInfo<SCREEN_ID extends Enum> {
  const RubigoChangeInfo(
    this.eventType,
    this.previousScreen,
    this.screenStack,
  );
}
```

### Navigating from controller code

If the controller has the `RubigoControllerMixin`, you can access the `rubigoRouter` directly. Otherwise you can use your favorite service locator to get access to your instance of `rubigoRouter`. The following navigation functions are available:


```dart
await rubigoRouter.pop();
await rubigoRouter.popTo(screenId);
await rubigoRouter.push(screenId);
await rubigoRouter.replaceStack(screens);
await rubigoRouter.remove(screenId);
```

### Check if the app is busy

The `RubigoRouter` can be used to mark and track wether the app is busy and should accept user
interaction. By default, the navigator places an `IgnorePointer` widget above the app, while the app
is marked as busy. This prevents the user from tampering with the app with touch events, while the
app is busy. Be careful that keyboard events are not blocked by this mechanism.

Check if the app is busy.

```dart
if (!rubigoRouter.busyService.isBusy) {
//Do something only when the app is not busy
}
```

Mark the app busy while some code executes:

```dart
await rubigoRouter.busyService.busyWrapper(() async {
  //Do something lengthy here that the user may/can not interrupt.
});
```

If you want to get notified when the app is marked as busy you can use the notifier.

```dart
final notifier = rubigoRouter.busyService.notifier;
```


Each stack manipulation function has an equivalent available in the `RubigoRouter.ui` namespace.
You can use these functions if you only want to perform the navigation when the app is not busy. This is useful if you wire up a
button pressed event directly to a navigating function.

```dart
await rubigoRouter.ui.pop();
await rubigoRouter.ui.popTo(screenId);
await rubigoRouter.ui.push(screenId);
await rubigoRouter.ui.replaceStack(screens);
await rubigoRouter.ui.remove(screenId);
```

```dart
Future<void> onS200ButtonPressed() async {
  await rubigoRouter.ui.push(Screens.s200);
}
```

### Back navigation
There are a number of ways the user can perform back navigation.  
1. `BackButton` in the `AppBar`.
2. Hardware back button on an Android device.
3. A back-gesture on an iOS device.
4. A predictive-back-gesture on an Android device.

A new challenge is that the app is informed afterwards by the `Navigator.onDidRemovePage` callback and that the animation has already started. This might not always be the preferred way. On iOS, the back gesture feels natural and disabling it altogether or only allow it on certain screens  would be bad for the user experience. 

Therefore this package adds the following:

1. `rubigoBackButton` to handle BackButton presses in the `AppBar`.
2. `RubigoRootBackButtonDispatcher` to handle Android hardware back button presses.
3. `RubigoBackGesture` widget to control wether or not to allow back-gestures on a screen.
4. `onDidRemovePage`, a way to catch back-gestures and to handle them gracefully.

With these tools together, the app is still able to decide asynchronously, with a call to the screen's `mayPop()`, if back navigation is allowed.  

1. Back button events:  
The animation is not started until it is clear that the user may navigate.
1. Back gesture events:  
If a back navigation is cancelled, the screen animates back to the original screen.

## Additional information

I am using this way of working with screens, controllers and navigation with Flutter apps since
2020.
The first implementation goes back to WindowsCE. It always served me well and has never let me
down.

For issues or pull request, go to the repository on GitHub.

Happy navigating!  
Sander Roest