part of 'dashboard_bloc.dart';

sealed class DashboardEvent {}

class DashboardInitEvent extends DashboardEvent {}

class DashboardRefreshDataEvent extends DashboardEvent {
  final Completer<void> completer;

  DashboardRefreshDataEvent({required this.completer});
}

class DashboardNextPageEvent extends DashboardEvent {}
