part of 'user_register_bloc.dart';

@immutable
abstract class UserRegisterState {}

class UserRegisterStateInitial extends UserRegisterState {}

class UserRegisterSuccess extends UserRegisterState {}

class UserRegisterFailed extends UserRegisterState {}

class UserRegisterStateGetProvinceSuccess extends UserRegisterState {}
