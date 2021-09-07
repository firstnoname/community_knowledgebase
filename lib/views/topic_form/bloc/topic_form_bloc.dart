import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_knowledgebase/bloc/base_bloc.dart';
import 'package:community_knowledgebase/models/models.dart';
import 'package:community_knowledgebase/models/topic.dart';
import 'package:community_knowledgebase/services/topic_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'topic_form_event.dart';
part 'topic_form_state.dart';

class TopicFormBloc extends BaseBloc<TopicFormEvent, TopicFormState> {
  BuildContext context;
  TopicFormBloc(this.context, {TopicFormState? initState})
      : super(context, initState ?? TopicFormInitialState()) {
    this.add(TopicFormInit());
  }

  Topic? topic = Topic();

  late Member _currentUser;

  @override
  Stream<TopicFormState> mapEventToState(
    TopicFormEvent event,
  ) async* {
    if (event is TopicFormInit) {
      yield TopicFormInitialState();
    } else if (event is TopicFormSubmitted) {
      _currentUser = appManagerBloc.member;
      topic!.createDate = Timestamp.now();
      topic!.member = Member(
        memberDisplayname: _currentUser.memberDisplayname,
        memberId: _currentUser.memberId,
      );
      var addTopic = await TopicServices().addTopic(topic!);
      if (addTopic != null)
        yield TopicFormSubmitSuccess();
      else
        yield TopicSubmitFailed();
    }
  }
}
