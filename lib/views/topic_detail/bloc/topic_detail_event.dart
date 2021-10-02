part of 'topic_detail_bloc.dart';

@immutable
abstract class TopicDetailEvent {}

class TopicDetailInitial extends TopicDetailEvent {}

class TopicAddedComment extends TopicDetailEvent {
  final String comment;

  TopicAddedComment(this.comment);
}

class TopicDetailEventButtonDeleteTopicPressed extends TopicDetailEvent {
  final String topicId;

  TopicDetailEventButtonDeleteTopicPressed(this.topicId);
}

class TopicDetailEventButtonDeleteCommentPressed extends TopicDetailEvent {
  final String topicId;
  final String commentId;

  TopicDetailEventButtonDeleteCommentPressed(
      {required this.commentId, required this.topicId});
}
