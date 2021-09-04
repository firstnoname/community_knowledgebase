part of 'knowledge_form_bloc.dart';

@immutable
abstract class KnowledgeFormEvent {}

class KnowledgeFormInitial extends KnowledgeFormEvent {}

class KnowledgeFormSubmitted extends KnowledgeFormEvent {
  final Knowledge knowledge;

  KnowledgeFormSubmitted(this.knowledge);
}

class KnowledgeChangedCategory extends KnowledgeFormEvent {
  final int index;

  KnowledgeChangedCategory(this.index);
}
