part of 'user_register_bloc.dart';

@immutable
abstract class UserRegisterState {}

class UserRegisterInitial extends UserRegisterState {}

class UserRegisterSuccess extends UserRegisterState {}

class UserRegisterFailed extends UserRegisterState {}
