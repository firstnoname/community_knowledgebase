part of 'knowledge_form_bloc.dart';

@immutable
abstract class KnowledgeFormState {}

class KnowledgeFormInitialState extends KnowledgeFormState {}

class KnowledgeAddSuccess extends KnowledgeFormState {}

class KnowledgeFormFailed extends KnowledgeFormState {}

class KnowledgeFormStateGetProvinceSuccess extends KnowledgeFormState {}

class KnowledgeFormStateGetDistrictSuccess extends KnowledgeFormState {}

class KnowledgeFormStateGetSubDistrictSuccess extends KnowledgeFormState {}
