import 'package:community_knowledgebase/bloc/blocs/app_manager_bloc.dart';
import 'package:community_knowledgebase/utilities/app_themes.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'views/views.dart';

class CommunityKnowledgebase extends StatelessWidget {
  CommunityKnowledgebase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppManagerBloc>(
          create: (_) => AppManagerBloc(),
        ),
      ],
      child: GestureDetector(
        child: MaterialApp(
          theme: appTheme(context),
          builder: EasyLoading.init(),
          title: 'คลังความรู้ชุมชน',
          home: homePage(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }

  homePage() {
    return BlocConsumer<AppManagerBloc, AppManagerState>(
      listener: (context, state) {},
      builder: (context, state) {
        Widget view;
        if (state is AppManagerInitial)
          // Change to splash screen, shouldn't be a LoginView.
          view = LoginView();
        else if (state is AppManagerStateAuthenticated)
          view = IndexView();
        else if (state is AppManagerStateUserRegisterFlowStarted)
          view = Container(
            child: Text('Register'),
          );
        // view = UserRegisterPolicyAgreement();
        else
          view = LoginView();
        return view;
      },
    );
  }
}
