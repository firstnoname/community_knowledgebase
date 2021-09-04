part of 'app_manager_bloc.dart';

@immutable
abstract class AppManagerEvent {}

class AppManagerStarted extends AppManagerEvent {}

class AppManagerLoginSuccessed extends AppManagerEvent {}

class AppManagerLogoutRequested extends AppManagerEvent {}
