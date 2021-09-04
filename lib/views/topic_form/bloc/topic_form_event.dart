part of 'topic_form_bloc.dart';

@immutable
abstract class TopicFormEvent {}

class TopicFormInit extends TopicFormEvent {}

class TopicFormSubmitted extends TopicFormEvent {}
