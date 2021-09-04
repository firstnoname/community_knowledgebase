import 'dart:async';

import 'package:community_knowledgebase/bloc/base_bloc.dart';
import 'package:community_knowledgebase/models/models.dart';
import 'package:community_knowledgebase/services/knowledge_services.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'knowledge_list_event.dart';
part 'knowledge_list_state.dart';

class KnowledgeListBloc
    extends BaseBloc<KnowledgeListEvent, KnowledgeListState> {
  BuildContext context;
  final String categoryType;

  KnowledgeListBloc(this.context, this.categoryType,
      {KnowledgeListState? initialState})
      : super(context, initialState ?? KnowledgeListInitialState()) {
    this.add(KnowledgeListInitial());
  }

  List<Knowledge> _knowledgeList = [];

  get knowledgeList => _knowledgeList;

  @override
  Stream<KnowledgeListState> mapEventToState(
    KnowledgeListEvent event,
  ) async* {
    if (event is KnowledgeListInitial) {
      _knowledgeList = await KnowledgeServices().readKnowledgeList(
          status: KnowledgeStatus.accepted, categoryName: categoryType);
      print('knwoledge list size -> ${knowledgeList.length}');
      yield KnowledgePrepareSuccess();
    }
  }
}
