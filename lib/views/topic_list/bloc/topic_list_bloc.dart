import 'dart:async';

import 'package:community_knowledgebase/bloc/base_bloc.dart';
import 'package:community_knowledgebase/models/models.dart';

import 'package:community_knowledgebase/services/topic_services.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'topic_list_event.dart';
part 'topic_list_state.dart';

class TopicListBloc extends BaseBloc<TopicListEvent, TopicListState> {
  BuildContext context;
  TopicListBloc(this.context, {TopicListState? initState})
      : super(context, initState ?? TopicListInitialState()) {
    this.add(TopicListInitial());
  }

  List<Topic> _topics = [];

  get topics => _topics;

  @override
  Stream<TopicListState> mapEventToState(
    TopicListEvent event,
  ) async* {
    if (event is TopicListInitial) {
      print('bloc init');
      _topics = await TopicServices().readTopics();
      yield GetToplicsSuccess();
    }
  }
}
