import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_knowledgebase/bloc/base_bloc.dart';
import 'package:community_knowledgebase/models/topic.dart';
import 'package:community_knowledgebase/services/topic_services.dart';
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

  @override
  Stream<TopicFormState> mapEventToState(
    TopicFormEvent event,
  ) async* {
    if (event is TopicFormInit) {
      yield TopicFormInitialState();
    } else if (event is TopicFormSubmitted) {
      topic!.createDate = Timestamp.now();
      var savedTopic = await TopicServices().addTopic(topic!);
      yield TopicFormSubmitSuccess();
    }
  }
}
