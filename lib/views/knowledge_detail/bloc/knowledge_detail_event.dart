part of 'knowledge_detail_bloc.dart';

@immutable
abstract class KnowledgeDetailEvent {}

class KnowledgeDetailInitial extends KnowledgeDetailEvent {}

class KnowledgeAccepted extends KnowledgeDetailEvent {}

class KnowledgeEjected extends KnowledgeDetailEvent {}
