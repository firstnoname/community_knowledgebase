import 'dart:async';

import 'package:community_knowledgebase/bloc/base_bloc.dart';
import 'package:community_knowledgebase/models/models.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../views.dart';

part 'index_event.dart';
part 'index_state.dart';

class IndexBloc extends BaseBloc<IndexEvent, IndexState> {
  IndexBloc(BuildContext context) : super(context, IndexInitialState()) {
    this.add(IndexViewInitial());
  }

  Member? _member = Member();

  get member => _member;

  @override
  Stream<IndexState> mapEventToState(
    IndexEvent event,
  ) async* {
    if (event is IndexViewInitial) {
      _member = appManagerBloc.member;
      yield IndexInitialState();
    } else if (event is LogoutPressed) {
      await appManagerBloc.userAuth.signOut();
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginView(),
        ),
      );
    }
  }
}
