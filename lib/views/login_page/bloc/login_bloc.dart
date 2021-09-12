import 'dart:async';

import 'package:community_knowledgebase/bloc/base_bloc.dart';
import 'package:community_knowledgebase/views/index_page/index_view.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends BaseBloc<LoginEvent, LoginState> {
  String? email;
  String? password;
  BuildContext context;
  LoginBloc(this.context) : super(context, LoginInitial());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    switch (event.runtimeType) {
      case LoginEmailPasswordSubmitted:
        await uiFeedback.showLoading();
        try {
          var userCredential =
              await appManagerBloc.userAuth.signInWithEmail(email!, password!);
          print('login status -> ${userCredential.user!.email}');
          if (userCredential.user != null) {
            // check current user.
            // var user = appManagerBloc.userAuth.firebaseCurrentUser;
            // appManagerBloc.currentUser =
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => IndexView(),
              ),
            );
            yield LoginEmailPasswordSubmitSuccess();
          } else
            yield LoginFailed();
        } catch (e) {
          print('login failed -> ${e.toString()}');
          yield LoginFailed();
        } finally {
          await uiFeedback.hideLoading();
        }
        break;
    }
  }
}
