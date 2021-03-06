import 'package:community_knowledgebase/utilities/constants.dart';
import 'package:community_knowledgebase/views/user_manager/bloc/user_manager_bloc.dart';
import 'package:community_knowledgebase/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserManagerView extends StatefulWidget {
  UserManagerView({Key? key}) : super(key: key);

  @override
  State<UserManagerView> createState() => _UserManagerViewState();
}

class _UserManagerViewState extends State<UserManagerView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [firstColor, secondColor],
              stops: [0.5, 1.0],
            ),
          ),
        ),
        title: Text('จัดการสถานะผู้ใช้งาน'),
        centerTitle: true,
      ),
      body: BlocProvider<UserManagerBloc>(
        create: (context) => UserManagerBloc(context),
        child: BlocBuilder<UserManagerBloc, UserManagerState>(
          builder: (context, state) {
            if (state is UserManagerStateGetUsersSuccess) {
              var users = state.users;
              return SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return SwitchableUserRole(user: users[index]);
                  },
                ),
              );
            } else if (state is UserManagerStateFailure) {
              return Container();
            } else
              return Container();
          },
        ),
      ),
    );
  }
}
