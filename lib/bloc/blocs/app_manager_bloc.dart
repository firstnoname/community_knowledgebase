import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:community_knowledgebase/models/models.dart';
import 'package:community_knowledgebase/services/user_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'app_manager_event.dart';
part 'app_manager_state.dart';

class AppManagerBloc extends Bloc<AppManagerEvent, AppManagerState> {
  late UserAuth _userAuth;

  UserAuth get userAuth => _userAuth;

  User? _currentUser;

  User? get currentUser => _currentUser;

  Member? _member;

  get member => _member;

  bool registerState = false;

  AppManagerBloc({AppManagerState? state, BuildContext? context})
      : super(state ?? AppManagerInitial()) {
    Firebase.initializeApp().then((value) async {
      _userAuth = UserAuth(this);
      this.add(AppManagerStarted());
    }).catchError((e) {
      print('Initial firebase failed : ${e.toString()}');
    });
  }

  @override
  Stream<AppManagerState> mapEventToState(
    AppManagerEvent event,
  ) async* {
    if (event is AppManagerStarted) {
      if (_userAuth.isLoggedIn()) {
        try {
          await _userAuth.checkCurrentUserProfile();
        } catch (e) {
          print(e.toString());
          yield await _logoutProcess();
        }
      } else {
        print('No persistent user data');
        yield AppManagerStateUnauthenticated();
      }
    } else if (event is AppManagerLoginSuccessed) {
      yield AppManagerStateAuthenticated();
    } else if (event is AppManagerLogoutRequested) {
    } else if (event is AppManagerStateUnauthenticated) {}
  }

  Future<AppManagerState> _logoutProcess() async {
    await _userAuth.signOut();
    _currentUser = null;
    return AppManagerStateUnauthenticated();
  }

  void updateCurrentUserProfile(User? user, Member? member) {
    _member = member;
    _currentUser = user;
  }
}
