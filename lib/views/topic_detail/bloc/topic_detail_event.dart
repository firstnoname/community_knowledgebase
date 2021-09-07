part of 'topic_detail_bloc.dart';

@immutable
abstract class TopicDetailEvent {}

class TopicDetailInitial extends TopicDetailEvent {}

class TopicAddedComment extends TopicDetailEvent {
  final String comment;

  TopicAddedComment(this.comment);
}
