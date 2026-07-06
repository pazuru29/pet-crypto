abstract interface class SessionScopeController {
  Future<void> initScope();

  Future<void> disposeScope();
}
