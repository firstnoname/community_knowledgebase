part of 'topic_detail_bloc.dart';

@immutable
abstract class TopicDetailState {}

class TopicDetailInitialState extends TopicDetailState {}

class TopicDetailInprogress extends TopicDetailState {}

class TopicDetailFailed extends TopicDetailState {
  final String reason;

  TopicDetailFailed(this.reason);
}

class TopicDetailDeleteTopicSuccess extends TopicDetailState {}

class TopicDetailDeleteCommentSuccess extends TopicDetailState {}

class TopicAddCommentSuccess extends TopicDetailState {}
