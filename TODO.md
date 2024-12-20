1. Let the internal stack be of type RubigoPage. 
In this way we would get rid of all find extensions
2. Instead of converting one screen to a stack, convert the whole stack at once.
In this way we would be able to compare the old stack to the new stack and adjust the animation accordingly. 
Now, e.g. when a screen in between is deleted, the same page would animate again on top.
3. 