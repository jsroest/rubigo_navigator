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

In kind of a way it is Navigator 1.0 **with** direct access to the page stack.

Managing the stack was never easier. 🥳 🚀

## Features

### Navigation
* **push**, push a specific screen on the stack.
* **pop**, pop the topmost screen from the stack.
* **popTo**, pop directly to a specific screen.
* **replaceStack**, instantly replace the stack with a new stack.
* **remove**, silently remove  a screen from the stack.

### Coding convenience
* From your **screen widget**, you have **direct access** to the corresponding **controller**.
* From your **controller**, you have direct access to the ```RubigoRouter``` and Flutter's ```Navigator```.

### Navigation events
#### Each controller is informed about the following navigation events:

* **onTop(** changeData **)** is called when the screen is on top of the stack.  
  Further navigation **is** allowed.
* **willShow(** changeData **)** is called when the screen is on top of the stack and **will** be shown.  
  Further navigation is **not** allowed.
* **isShown(** changeData **)** is called when the screen is on top of the stack and is actually shown.  
  Further navigation is **not** allowed.
* **bool mayPop()** is called when the screen is about to be popped from the stack.  
  If you return ```false```, the pop is cancelled.  
  Further navigation is **not** allowed.

#### changeData contains the following data:
* **eventType:** push, pop, popTo or replaceStack.
* **previousScreen:** the screen where we are coming from.
* **screenStack:** a copy of the current screen stack.

With this data, the controller can decide what to do next.

#### Typical use cases

* **onTop()**, Navigate to other screens without the user noticing it.
* **willShow()**, Get data from an asynchronous source, like a local database. The screen will be shown as soon as the data has arrived.
* **isShown()**: If you want to be sure that page is shown before starting some lengthy processing. If you call code that is heavy on the UI thread, this makes sure that at least the page is shown before the processing starts.

### Know when the app is busy and absorb touch events
This is not mandatory to use, but it is a nice addition, especially for Line of Business apps.  

The ```RubigoRouter``` holds a ```RubigoBusyService```. Whenever navigation is in progress, or when the app executes some code in a ```busyWrapper```, the app marks itself as **busy**.

When the app is **busy** and the ```RubigoBusyWidget``` is used, all touch events are absorbed. This protects your app in a simple and easy to reason about way.

## Getting started

At the time of writing, this package requires:
* dart sdk: 3.0.0 or greater
* flutter version 3.10.0 or greater

## Setting up the app

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
// It's important that the controllers are registered as singletons, unless you
// know what you are doing :-)
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
  RubigoScreen(
    Screens.s300,
    S300Screen(),
    () => holder.get(S300Controller.new),
  ),
];
```

Create a `RubigoRouter` and pass the `availableScreens` and splash screen.

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

Create a `RubigoMaterialApp`, pass the `initAndGetFirstScreen` and `routerDelegate`.  

```dart
runApp(
  RubigoMaterialApp(
    initAndGetFirstScreen: initAndGetFirstScreen,
    routerDelegate: routerDelegate,
  ),
);
```

## Setting up screens  
You can use any widget as a screen widget.  

If you add the `RubigoScreenMixin`, you can access the controller of your page directly in your code. This controller is wired up during the initialization phase.

### example usage

```dart
ElevatedButton(
  onPressed: controller.onS200ButtonPressed,
  child: const Text('Push S200'),
),
```

## Setting up controllers  
You can use any class as a controller for your screen.  

If you add the `RubigoControllerMixin`, you can access the router of you app directly in your code. The router is wired up during the initialization phase.

### Navigation events  
Each controller with the `RubigoControllerMixin` gets access to the following navigation events:

```dart
@override
Future<void> onTop(RubigoChangeInfo<Screens> changeInfo) async {}

@override
Future<void> willShow(RubigoChangeInfo<Screens> changeInfo) async {}

@override
Future<void> isShown(RubigoChangeInfo<Screens> changeInfo) async {}

@override
Future<bool> mayPop() => Future.value(true);
```

The `onTop` event allows further navigation. After navigating and finishing all events, the Flutter framework is informed about the new  state of the screen stack. This will result in a single page transition, from the old screen to the new screen.

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
  final EventType eventType;
  final Screens? previousScreen;
  final List<Screens> screenStack;
}

```

### Navigating from controller code
If the controller has the `RubigoControllerMixin, you can manipulate the stack with these functions.  

```dart
await rubigoRouter.pop();
await rubigoRouter.popTo(screenId);
await rubigoRouter.push(screenId);
await rubigoRouter.replaceStack(screens);
rubigoRouter.remove(screenId);
```

### Check if the app is busy  

The `RubigoRouter` can be used to mark and track wether the app is busy and should accept user interaction. By default, the navigator places an `IgnorePointer` widget above the app, while the app is marked as busy. This prevents the user from tampering with the app with touch events, while the app is busy. Be careful that keyboard events are not blocked by this mechanism.

Check if the app is busy.

```dart
if (!rubigoRouter.busyService.isBusy) {
  //Do something only when the app is not busy
}
```

Mark the app busy while some code executes:

```dart
await rubigoRouter.busyService.busyWrapper(() async {
  //Do something lengthy here that the use may not interrupt.
});
```

If you want to get notified when the app is marked as busy you can use the notifier.  

```dart
final notifier = rubigoRouter.busyService.notifier;
```

All stack manipulation functions have the optional parameter `ignoreWhenBusy`. You can use this if you only want to perform the navigation when the app is not busy. This is useful if you wire up a button pressed event directly to a navigating function.

```dart
Future<void> onS200ButtonPressed() async {
  await rubigoRouter.push(Screens.s200, ignoreWhenBusy: true);
}
```

TODO: Include short and useful examples for package users. Add longer examples  
to `/example` folder.

```dart  
const like = 'sample';  
```  

## Additional information

TODO: Tell users more about the package: where to find more information, how to  
contribute to the package, how to file issues, what response they can expect  
from the package authors, and more.