import 'dart:async';

import 'package:community_knowledgebase/bloc/base_bloc.dart';
import 'package:community_knowledgebase/models/models.dart';
import 'package:community_knowledgebase/services/knowledge_services.dart';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'knowledge_detail_event.dart';
part 'knowledge_detail_state.dart';

class KnowledgeDetailBloc
    extends BaseBloc<KnowledgeDetailEvent, KnowledgeDetailState> {
  Knowledge knowledge;
  KnowledgeDetailBloc(BuildContext context, this.knowledge,
      {KnowledgeDetailState? initState})
      : super(context, initState ?? KnowledgeDetailInitialState()) {
    this.add(KnowledgeDetailInitial());
  }

  Member? _member = Member();

  get member => _member;

  @override
  Stream<KnowledgeDetailState> mapEventToState(
    KnowledgeDetailEvent event,
  ) async* {
    if (event is KnowledgeDetailInitial) {
      _member = appManagerBloc.member;
      // update view counter.
      Member user = appManagerBloc.member;
      user.memberStatus == 'user'
          ? KnowledgeServices().increaseView(knowledge.knowledgeId!)
          : null;
      yield KnowledgeDetailInitialState();
    } else if (event is KnowledgeAccepted) {
      String acceptedKnowledgeId = '';
      try {
        acceptedKnowledgeId =
            await KnowledgeServices().acceptKnowledge(knowledge.knowledgeId!);
      } catch (e) {
        print('update status failed -> $e');
      }
      if (acceptedKnowledgeId == '') {
        yield KnowledgeDetailFailed();
      } else {
        yield KnowledgeAcceptSuccess();
      }
    } else if (event is KnowledgeEjected) {
      String rejectedKnowledgeId = '';
      try {
        rejectedKnowledgeId =
            await KnowledgeServices().acceptKnowledge(knowledge.knowledgeId!);
      } catch (e) {
        print('update status failed -> $e');
      }
      if (rejectedKnowledgeId == '') {
        yield KnowledgeDetailFailed();
      } else {
        yield KnowledgeEjectSuccess();
      }
    }
  }
}
