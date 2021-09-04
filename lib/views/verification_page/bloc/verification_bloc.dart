import 'dart:async';

import 'package:community_knowledgebase/bloc/base_bloc.dart';
import 'package:community_knowledgebase/models/models.dart';
import 'package:community_knowledgebase/services/knowledge_services.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'verification_event.dart';
part 'verification_state.dart';

class VerificationBloc extends BaseBloc<VerificationEvent, VerificationState> {
  VerificationBloc(BuildContext context, {VerificationState? initState})
      : super(context, initState ?? VerificationInitialState()) {
    this.add(VerficationInitial());
  }

  List<Knowledge> _knowledgeList = [];

  get knowledgeList => _knowledgeList;

  @override
  Stream<VerificationState> mapEventToState(
    VerificationEvent event,
  ) async* {
    if (event is VerficationInitial) {
      yield VerficationInprogress();
      _knowledgeList = await KnowledgeServices()
          .readKnowledgeList(status: KnowledgeStatus.pending);
      print('knowledge list -> ${_knowledgeList.length}');
      yield VerificationPrepareSuccess();
    }
  }
}
