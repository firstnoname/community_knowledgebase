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
  get provices => _provinces;

  List<BaseAddress> _district = [];
  get districts => _district;

  List<BaseAddress> _subDistrict = [];
  // get subDistricts => _subDistrict;

  late BaseAddress _currentSubDistrict;
  // get currentSubDistrict => _currentSubDistrict;

  String _reasonError = '';

  @override
  Stream<UserRegisterState> mapEventToState(
    UserRegisterEvent event,
  ) async* {
    if (event is UserRegisterEventInitial) {
      // TODO *** ต้องทำ feature เลือกจังหวัดให้ได้
      // ติดปัญหาตอน decode json ไม่ได้.
      // _provinces = await AddressServices().getProvices();
      // print('provinces -> ${_provinces.length}');
      this.add(UserRegisterEventPrepareAddress());
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
    } else if (event is UserRegisterEventPressProvince) {
      yield UserRegisterStateGetProvinceSuccess();
    } else if (event is UserRegisterEventPressDistrict) {
    } else if (event is UserRegisterEventPressSubDistrict) {
      _currentSubDistrict = event.selectedSubDistrict;
      yield UserRegisterStatePrepareAddressSuccess(
          _subDistrict, _currentSubDistrict);
    } else if (event is UserRegisterEventPrepareAddress) {
      _subDistrict = await AddressServices().getSubDistricts();
      _currentSubDistrict = _subDistrict.first;

      if (_subDistrict.length == 0)
        yield UserRegisterFailed();
      else
        yield UserRegisterStatePrepareAddressSuccess(
            _subDistrict, _currentSubDistrict);
    }
  }
}
