import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

class AppBlocObserver extends BlocObserver {
  final Logger _log = Logger('AppBlocObserver');

  @override
  void onCreate(BlocBase bloc) {
    _logger('Register BLOC: ${bloc.state.toString()}');
    super.onCreate(bloc);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    _logger(
      "${bloc.runtimeType}: Current State: ${change.currentState.toString()} | Next State: ${change.nextState.toString()}",
    );
    super.onChange(bloc, change);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    _logger('Event: ${event?.toString()}');
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
  }

  @override
  void onClose(BlocBase bloc) {
    _logger('Close BLOC: ${bloc.toString()}');
    super.onClose(bloc);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    _log.severe('Error:', error, stackTrace);
    super.onError(bloc, error, stackTrace);
  }

  void _logger(String text) {
    _log.fine(text);
  }
}
