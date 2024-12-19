sealed class NavigationType<SCREEN_ID> {
  NavigationType();
}

class Push<SCREEN_ID extends Enum> extends NavigationType<SCREEN_ID> {
  Push(this.screenId);

  SCREEN_ID screenId;
}

class Pop<SCREEN_ID extends Enum> extends NavigationType<SCREEN_ID> {
  Pop();
}

class PopTo<SCREEN_ID extends Enum> extends NavigationType<SCREEN_ID> {
  PopTo(this.screenId);

  SCREEN_ID screenId;
}
