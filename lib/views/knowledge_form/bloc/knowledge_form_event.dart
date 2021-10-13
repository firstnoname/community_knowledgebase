part of 'knowledge_form_bloc.dart';

@immutable
abstract class KnowledgeFormEvent {}

class KnowledgeFormInitial extends KnowledgeFormEvent {}

class KnowledgeFormSubmitted extends KnowledgeFormEvent {
  final Knowledge knowledge;
  final List<Uint8List>? images;
  final video;

  KnowledgeFormSubmitted(this.knowledge, {this.images, this.video});
}

class KnowledgeChangedCategory extends KnowledgeFormEvent {
  final int index;

  KnowledgeChangedCategory(this.index);
}

class KnowledgeFormEventPressProvince extends KnowledgeFormEvent {}

class KnowledgeFormEventPressDistrict extends KnowledgeFormEvent {}

class KnowledgeFormEventPressSubDistrict extends KnowledgeFormEvent {}
