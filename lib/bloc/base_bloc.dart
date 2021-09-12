import 'package:community_knowledgebase/utilities/ui_feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/app_manager_bloc.dart';

abstract class BaseBloc<Event, State> extends Bloc<Event, State> {
  final AppManagerBloc appManagerBloc;
  final BuildContext context;
  final UIFeedback uiFeedback;

  BaseBloc(BuildContext context, State initialState)
      : uiFeedback = UIFeedback(context),
        appManagerBloc = BlocProvider.of<AppManagerBloc>(context),
        context = context,
        super(initialState);
}
