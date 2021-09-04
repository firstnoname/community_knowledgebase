import 'dart:async';

import 'package:community_knowledgebase/bloc/base_bloc.dart';
import 'package:community_knowledgebase/models/models.dart';
import 'package:community_knowledgebase/services/category_services.dart';
import 'package:community_knowledgebase/services/knowledge_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'knowledge_form_event.dart';
part 'knowledge_form_state.dart';

class KnowledgeFormBloc
    extends BaseBloc<KnowledgeFormEvent, KnowledgeFormState> {
  BuildContext context;

  KnowledgeFormBloc(this.context, {KnowledgeFormState? initState})
      : super(context, initState ?? KnowledgeFormInitialState()) {
    this.add(KnowledgeFormInitial());
  }

  Knowledge? knowledgeInfo = Knowledge();

  get knowledgeData => knowledgeInfo;

  late User _currentUser;

  List<Category> _categories = [];

  get categories => _categories;

  @override
  Stream<KnowledgeFormState> mapEventToState(
    KnowledgeFormEvent event,
  ) async* {
    if (event is KnowledgeFormInitial) {
      _categories = await CategoryServices().readCategories();
      _currentUser = appManagerBloc.currentUser!;
      yield KnowledgeFormInitialState();
    } else if (event is KnowledgeFormSubmitted) {
      knowledgeInfo = event.knowledge;
      knowledgeInfo!.member = Member(
        memberDisplayname: _currentUser.displayName,
        memberId: _currentUser.uid,
      );
      KnowledgeServices().addKnowledge(knowledgeInfo!);
    } else if (event is KnowledgeChangedCategory) {
      knowledgeInfo?.category = categories[event.index];
    }
  }
}
