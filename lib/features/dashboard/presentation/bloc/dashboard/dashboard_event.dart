part of 'dashboard_bloc.dart';

sealed class DashboardEvent {}

class DashboardInitEvent extends DashboardEvent {}

class DashboardRefreshDataEvent extends DashboardEvent {}

class DashboardNextPageEvent extends DashboardEvent {}
