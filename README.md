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

## Usage

Create an enum with all your screens:

```dart
enum Screens {
  splashScreen,
  s100,
  s200,
}
```

Create a list that combines the enum, with a widget and a controller.
```dart
// holder = your favorite service locator and/or dependency injection package
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

Create a `RubigoRouter` and pass the `availableScreens` and the `splashScreenId`.

```dart
final rubigoRouter = RubigoRouter<Screens>(
  availableScreens: availableScreens,
  splashScreenId: Screens.splashScreen,
);
```

Create a function that holds you initialization code and that returns the screen to show when the initialization is complete.

```dart
Future<Screens> initAndGetFirstScreen() async {
  //Initialize your app here.
  //Create objects with your favorite dependency injection framework
  //and store them in your favorite service locator.
  return Screens.s100;
}
```

Create a `RubigoMaterialApp` or implement your own and pass it to `runApp`

```dart
void main() {
  runApp(
    RubigoMaterialApp(
      initAndGetFirstScreen: initAndGetFirstScreen,
      routerDelegate: RubigoRouterDelegate(
        rubigoRouter: rubigoRouter,
      ),
    ),
  );
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