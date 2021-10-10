import 'dart:async';

import 'package:community_knowledgebase/bloc/base_bloc.dart';
import 'package:community_knowledgebase/models/models.dart';
import 'package:community_knowledgebase/services/services.dart';
import 'package:community_knowledgebase/services/user_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'user_register_event.dart';
part 'user_register_state.dart';

class UserRegisterBloc extends BaseBloc<UserRegisterEvent, UserRegisterState> {
  UserRegisterBloc(BuildContext context)
      : super(context, UserRegisterStateInitial()) {
    this.add(UserRegisterEventInitial());
  }

  String? email;
  String? displayName;
  String? password;

  List<BaseAddress> _provinces = [];
  late BaseAddress _currentProvince;

  List<BaseAddress> _district = [];
  late BaseAddress _currentDistrict;

  List<BaseAddress> _subDistrict = [];
  late BaseAddress _currentSubDistrict;

  String _reasonError = '';

  @override
  Stream<UserRegisterState> mapEventToState(
    UserRegisterEvent event,
  ) async* {
    if (event is UserRegisterEventInitial) {
      this.add(UserRegisterEventPrepareProvince());
      yield UserRegisterStateInitial();
    } else if (event is UserSubmittedForm) {
      await uiFeedback.showLoading();
      try {
        var userCredential = await appManagerBloc.userAuth
            .signUpWithEmail(
          email!,
          password!,
          displayName!,
        )
            .catchError((e) {
          _reasonError = e.toString();
        });
        // เพิ่ม user ไปยัง Firebase storage.
        if (userCredential != null) {
          userCredential as User;
          await UserServices()
              .addUser(
            userCredential,
            displayName!,
            Address(subDistrict: _currentSubDistrict),
          )
              .catchError((e) {
            _reasonError = e.toString();
          });
          this.appManagerBloc.userAuth.signInWithEmail(email!, password!);
          await uiFeedback.hideLoading();
          Navigator.pop(context);
        } else {
          await uiFeedback.hideLoading();
          print("Signup failed -> $_reasonError");
          await uiFeedback.showErrorDialog(context,
              title: 'เกิดข้อผิดพลาด', content: _reasonError);

          yield UserRegisterFailed();
        }
      } catch (e) {
        print("Signup failed -> ${e.toString()}");
      }
    } else if (event is UserRegisterEventPrepareProvince) {
      // Get province.
      // _provinces = await AddressServices().getProvices();
      _provinces = await AddressServices().getProvinceAPI();
      _currentProvince = _provinces.first;

      yield UserRegisterStateGetProvinceSuccess(_provinces, _provinces.first);
    } else if (event is UserRegisterEventPressProvince) {
      _currentProvince = event.selectedProvince;
      // Add event to call get district.
      this.add(UserRegisterEventPrepareDistrict());
      yield UserRegisterStateGetProvinceSuccess(_provinces, _currentProvince);
    } else if (event is UserRegisterEventPrepareDistrict) {
      // Get district.
      _district =
          await AddressServices().getDistrictAPI(_currentProvince.name!);
      _currentDistrict = _district.first;
      yield UserRegisterStateGetDistrictSuccess(_district, _district.first);
    } else if (event is UserRegisterEventPressDistrict) {
      _currentDistrict = event.selectedDistrict;
      this.add(UserRegisterEventPrepareSubDistrict());
      yield UserRegisterStateGetDistrictSuccess(_district, _currentDistrict);
    } else if (event is UserRegisterEventPrepareSubDistrict) {
      // Get sub district.
      // _subDistrict =
      //     await AddressServices().getSubDistrict(_currentDistrict.id);
      _subDistrict = await AddressServices()
          .getSubDistrictAPI(_currentProvince.name!, _currentDistrict.name!);
      _currentSubDistrict = _subDistrict.first;
      yield UserRegisterStateGetSubDistrictSuccess(
          _subDistrict, _subDistrict.first);
    } else if (event is UserRegisterEventPressSubDistrict) {
      _currentSubDistrict = event.selectedSubDistrict;
      yield UserRegisterStateGetSubDistrictSuccess(
          _subDistrict, _currentSubDistrict);
    } else if (event is UserRegisterEventPrepareAddress) {}
  }
}
