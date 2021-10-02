part of 'user_manager_bloc.dart';

@immutable
abstract class UserManagerState {}

class UserManagerInitial extends UserManagerState {}

class UserManagerStateGetUsersSuccess extends UserManagerState {
  final List<Member> users;

  UserManagerStateGetUsersSuccess(this.users);
}

class UserManagerStateFailure extends UserManagerState {}
