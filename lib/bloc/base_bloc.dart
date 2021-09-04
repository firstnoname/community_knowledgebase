import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/app_manager_bloc.dart';

abstract class BaseBloc<Event, State> extends Bloc<Event, State> {
  final AppManagerBloc appManagerBloc;
  final BuildContext context;

  BaseBloc(BuildContext context, State initialState)
      : appManagerBloc = BlocProvider.of<AppManagerBloc>(context),
        context = context,
        super(initialState);
}
