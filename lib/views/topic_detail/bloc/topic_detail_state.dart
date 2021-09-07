part of 'topic_detail_bloc.dart';

@immutable
abstract class TopicDetailState {}

class TopicDetailInitialState extends TopicDetailState {}

class TopicDetailInprogress extends TopicDetailState {}

class TopicDetailFailed extends TopicDetailState {
  final String reason;

  TopicDetailFailed(this.reason);
}

class TopicAddCommentSuccess extends TopicDetailState {}
