import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_knowledgebase/bloc/base_bloc.dart';
import 'package:community_knowledgebase/models/models.dart';
import 'package:community_knowledgebase/services/comment_services.dart';
import 'package:community_knowledgebase/services/topic_services.dart';
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

  late Member _member = Member();
  get member => _member;

  @override
  Stream<TopicDetailState> mapEventToState(
    TopicDetailEvent event,
  ) async* {
    if (event is TopicDetailInitial) {
      _member = appManagerBloc.member;
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
    } else if (event is TopicDetailEventButtonDeleteTopicPressed) {
      bool isSuccess = await TopicServices().deleteTopic(event.topicId);
      if (isSuccess) {
        yield TopicDetailDeleteTopicSuccess();
      } else
        yield TopicDetailFailed('ลบข้อมูลไม่สำเร็จ');
    } else if (event is TopicDetailEventButtonDeleteCommentPressed) {
      bool isSuccess = await CommentServices()
          .deleteComment(topicId: event.topicId, commentId: event.commentId);
      if (isSuccess) {
        _comments.removeWhere((element) => element.id == event.commentId);
        yield TopicDetailDeleteCommentSuccess();
      } else
        yield TopicDetailFailed('ลบข้อมูลไม่สำเร็จ');
    }
  }
}
