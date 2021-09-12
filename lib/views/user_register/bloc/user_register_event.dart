part of 'user_register_bloc.dart';

@immutable
abstract class UserRegisterEvent {}

class UserRegisterEventInitial extends UserRegisterEvent {}

class UserSubmittedForm extends UserRegisterEvent {}

class UserAutoLogin extends UserRegisterEvent {}

class UserRegisterEventPressProvince extends UserRegisterEvent {}

class UserRegisterEventPressDistrict extends UserRegisterEvent {}

class UserRegisterEventPressSubDistrict extends UserRegisterEvent {}
