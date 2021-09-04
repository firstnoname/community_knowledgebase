part of 'user_register_bloc.dart';

@immutable
abstract class UserRegisterEvent {}

class UserSubmittedForm extends UserRegisterEvent {}

class UserAutoLogin extends UserRegisterEvent {}
