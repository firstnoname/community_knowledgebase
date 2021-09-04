part of 'knowledge_detail_bloc.dart';

@immutable
abstract class KnowledgeDetailState {}

class KnowledgeDetailInitialState extends KnowledgeDetailState {}

class KnowledgeDetailFailed extends KnowledgeDetailState {}

class KnowledgeAcceptSuccess extends KnowledgeDetailState {}

class KnowledgeEjectSuccess extends KnowledgeDetailState {}
