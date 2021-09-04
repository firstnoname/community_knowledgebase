part of 'app_manager_bloc.dart';

@immutable
abstract class AppManagerState {}

class AppManagerInitial extends AppManagerState {}

class AppManagerStateInitialFailure extends AppManagerState {
  final String reason;

  AppManagerStateInitialFailure(this.reason);
}

class AppManagerStateAuthenticated extends AppManagerState {}

class AppManagerStateUnauthenticated extends AppManagerState {
  final String? reason;
  AppManagerStateUnauthenticated() : reason = null;
  AppManagerStateUnauthenticated.withReason(this.reason);
}

class AppManagerStateUserRegisterFlowStarted extends AppManagerState {}

class AppManagerStateLocationPermissionDenied extends AppManagerState {}
