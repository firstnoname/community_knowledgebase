part of 'knowledge_list_bloc.dart';

@immutable
abstract class KnowledgeListEvent {}

class KnowledgeListInitial extends KnowledgeListEvent {}

class KnowledgeListSelected extends KnowledgeListEvent {}
