part of 'user_register_bloc.dart';

@immutable
abstract class UserRegisterEvent {}

class UserRegisterEventInitial extends UserRegisterEvent {}

class UserSubmittedForm extends UserRegisterEvent {}

class UserAutoLogin extends UserRegisterEvent {}

class UserRegisterEventPrepareProvince extends UserRegisterEvent {}

class UserRegisterEventPressProvince extends UserRegisterEvent {
  final BaseAddress selectedProvince;

  UserRegisterEventPressProvince(this.selectedProvince);
}

class UserRegisterEventPrepareDistrict extends UserRegisterEvent {}

class UserRegisterEventPressDistrict extends UserRegisterEvent {
  final BaseAddress selectedDistrict;

  UserRegisterEventPressDistrict(this.selectedDistrict);
}

class UserRegisterEventPrepareSubDistrict extends UserRegisterEvent {}

class UserRegisterEventPressSubDistrict extends UserRegisterEvent {
  final BaseAddress selectedSubDistrict;

  UserRegisterEventPressSubDistrict(this.selectedSubDistrict);
}

class UserRegisterEventPrepareAddress extends UserRegisterEvent {}
