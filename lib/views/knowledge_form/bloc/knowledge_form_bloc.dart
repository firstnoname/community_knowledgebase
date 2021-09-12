import 'dart:async';

import 'package:community_knowledgebase/bloc/base_bloc.dart';
import 'package:community_knowledgebase/models/models.dart';
import 'package:community_knowledgebase/services/address_services.dart';
import 'package:community_knowledgebase/services/category_services.dart';
import 'package:community_knowledgebase/services/knowledge_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
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

  Knowledge? knowledgeInfo = Knowledge(images: []);

  get knowledgeData => knowledgeInfo;

  late User _currentUser;

  List<Category> _categories = [];
  get categories => _categories;

  @override
  Stream<KnowledgeFormState> mapEventToState(
    KnowledgeFormEvent event,
  ) async* {
    try {
      if (event is KnowledgeFormInitial) {
        _categories = await CategoryServices().readCategories();
        _currentUser = appManagerBloc.currentUser!;
        yield KnowledgeFormInitialState();
      } else if (event is KnowledgeFormSubmitted) {
        await uiFeedback.showLoading();
        knowledgeInfo = event.knowledge;
        knowledgeInfo!.member = Member(
          memberDisplayname: _currentUser.displayName,
          memberId: _currentUser.uid,
        );
        if (knowledgeInfo!.category == null)
          knowledgeInfo!.category = categories[0];
        var result = await KnowledgeServices()
            .addKnowledge(knowledgeInfo!, image: event.image);
        await uiFeedback.hideLoading();
        if (result != null) yield KnowledgeAddSuccess();
      } else if (event is KnowledgeChangedCategory) {
        print('selected category -> ${categories[event.index]}');
        knowledgeInfo?.category = categories[event.index];
      }
    } on Exception catch (e) {
      print('Knowledge form bloc was exception ${e.toString()}');
    }
  }
}
