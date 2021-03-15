# Rubigo Navigator
  
An opinionated navigator.

Made possible by Flutter's Navigator 2.0
  
## Getting Started
The Rubigo Navigator consists of several classes and base classes, that makes navigation and keeping separation of concerns easy.

This navigator informs Flutter's standard navigator about page changes
after all navigation is completed. In this way you can traverse pages
without having multiple page animations triggered. It also keeps all
your code where it belongs, so you will have separation of
concerns.

## RubigoApp
Convenience widget for easy initial app setup.

## RubigoNavigator&lt;Pages&gt;
Navigator of type Pages (enum). Provides strongly typed navigation.

Methods:
- **pop()**  
     Pops the current page of the stack
- **push(enum id)**  
     Pushes the page with id on the stack
- **popTo(enum id)**  
     Pops directly to the specified page
- **remove(enum id)**  
     Removes page with id unconditionally from the stack  
  
## RubigoController (base class)
This contains the page logic and transient state.

Properties:
- **rubigoNavigator**  
     Allows easy access to navigation  

Events:  
- **onTop(stackChange, previousPage)**  
     In this event the navigation can be continued (push/pop/popTo)  
- **willShow()**  
     This event can be used to get data (also from async sources) for the page to display. The page transition will take place, right after this event.  
- **bool mayPop()**  
     This function can be used to block a pop().  
  
## RubigoPage (base class)
This contains the view.

Properties:
- **controllerProvider**  
     Allows easy access the corresponding Controller  
  