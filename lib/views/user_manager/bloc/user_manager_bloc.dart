import 'package:bloc/bloc.dart';
import 'package:community_knowledgebase/bloc/base_bloc.dart';
import 'package:community_knowledgebase/models/member.dart';
import 'package:community_knowledgebase/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'user_manager_event.dart';
part 'user_manager_state.dart';

class UserManagerBloc extends BaseBloc<UserManagerEvent, UserManagerState> {
  BuildContext context;
  UserManagerBloc(this.context) : super(context, UserManagerInitial()) {
    this.add(UserManagerEventInitial());
  }

  @override
  Stream<UserManagerState> mapEventToState(UserManagerEvent event) async* {
    if (event is UserManagerEventInitial) {
      var userList = await UserServices().getUserList('');

      if (userList.length != 0)
        yield UserManagerStateGetUsersSuccess(userList);
      else
        yield UserManagerStateFailure();
    }
  }
}
