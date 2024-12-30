1. Let the internal stack be of type RubigoScreen. In this way we would get rid of all find extensions

Done: Although it we could not get rid of the extensions.

1. Instead of converting one screen to a stack, convert the whole stack at once. In this way we would be able to compare the old stack to the new stack and adjust the animation accordingly. 
Now, e.g. when a screen in between is deleted, the same page would animate again on top.

Done.

1. Add a way to notify listeners that the navigator is busy. We need this for our busy_service which prevents user input while navigating.



1. 2.Add a splash screen while the app is loading (during app startup).

Done.