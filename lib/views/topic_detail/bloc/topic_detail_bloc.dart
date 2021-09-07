import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_knowledgebase/bloc/base_bloc.dart';
import 'package:community_knowledgebase/models/models.dart';
import 'package:community_knowledgebase/services/comment_services.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'topic_detail_event.dart';
part 'topic_detail_state.dart';

class TopicDetailBloc extends BaseBloc<TopicDetailEvent, TopicDetailState> {
  Topic topic;
  TopicDetailBloc(BuildContext context, this.topic,
      {TopicDetailState? initState})
      : super(context, initState ?? TopicDetailInitialState()) {
    this.add(TopicDetailInitial());
  }

  List<Comment> _comments = [];

  get comments => _comments;

  @override
  Stream<TopicDetailState> mapEventToState(
    TopicDetailEvent event,
  ) async* {
    if (event is TopicDetailInitial) {
      // get comment.
      _comments = await CommentServices().readComment(topic.topicId!);
      yield TopicDetailInitialState();
    } else if (event is TopicAddedComment) {
      Comment _comment = Comment(
          comment: event.comment,
          member: appManagerBloc.member,
          createDate: Timestamp.now());
      var result = await CommentServices().addComment(topic.topicId!, _comment);
      if (result != null) {
        _comments.add(_comment);
        yield TopicAddCommentSuccess();
      } else {
        yield TopicDetailFailed('Add comment failed');
      }
    }
  }
}
