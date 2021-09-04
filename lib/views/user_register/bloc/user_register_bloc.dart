import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:community_knowledgebase/bloc/base_bloc.dart';
import 'package:community_knowledgebase/services/user_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'user_register_event.dart';
part 'user_register_state.dart';

class UserRegisterBloc extends BaseBloc<UserRegisterEvent, UserRegisterState> {
  String? email;
  String? displayName;
  String? password;

  UserRegisterBloc(BuildContext context)
      : super(context, UserRegisterInitial());

  @override
  Stream<UserRegisterState> mapEventToState(
    UserRegisterEvent event,
  ) async* {
    if (event is UserSubmittedForm) {
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
    }
  }
}
