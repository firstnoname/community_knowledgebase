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
  get subDistricts => _subDistrict;

  @override
  Stream<UserRegisterState> mapEventToState(
    UserRegisterEvent event,
  ) async* {
    if (event is UserRegisterEventInitial) {
      // TODO *** ต้องทำ feature เลือกจังหวัดให้ได้
      // ติดปัญหาตอน decode json ไม่ได้.
      // _provinces = await AddressServices().getProvices();
      // print('provinces -> ${_provinces.length}');
    } else if (event is UserSubmittedForm) {
      try {
        var userCredential = await appManagerBloc.userAuth
            .signUpWithEmail(email!, password!, displayName!);
        if (userCredential != null) {
          userCredential as User;
          await UserServices().addUser(userCredential, displayName!);
          this.appManagerBloc.userAuth.signInWithEmail(email!, password!);
        } else {
          yield UserRegisterFailed();
        }
      } catch (e) {
        print("Signup failed -> ${e.toString()}");
        yield UserRegisterFailed();
      }
    } else if (event is UserRegisterEventPressProvince) {
      yield UserRegisterStateGetProvinceSuccess();
    } else if (event is UserRegisterEventPressDistrict) {
    } else if (event is UserRegisterEventPressSubDistrict) {}
  }
}
