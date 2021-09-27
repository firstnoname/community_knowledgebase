part of 'user_register_bloc.dart';

@immutable
abstract class UserRegisterState {}

class UserRegisterStateInitial extends UserRegisterState {}

class UserRegisterSuccess extends UserRegisterState {}

class UserRegisterFailed extends UserRegisterState {}

class UserRegisterStateGetProvinceSuccess extends UserRegisterState {
  final List<BaseAddress> provinceList;
  final BaseAddress currentProvince;

  UserRegisterStateGetProvinceSuccess(this.provinceList, this.currentProvince);
}

class UserRegisterStateGetDistrictSuccess extends UserRegisterState {
  final List<BaseAddress> districtList;
  final BaseAddress currentDistrict;

  UserRegisterStateGetDistrictSuccess(this.districtList, this.currentDistrict);
}

class UserRegisterStateGetSubDistrictSuccess extends UserRegisterState {
  final List<BaseAddress> subDistrictList;
  final BaseAddress currentSubDistrict;

  UserRegisterStateGetSubDistrictSuccess(
      this.subDistrictList, this.currentSubDistrict);
}

class UserRegisterStatePrepareAddressSuccess extends UserRegisterState {}
