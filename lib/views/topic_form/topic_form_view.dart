import 'package:community_knowledgebase/models/topic.dart';
import 'package:community_knowledgebase/views/topic_form/bloc/topic_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopicFormView extends StatelessWidget {
  final Function callBackInitState;
  TopicFormView({Key? key, required this.callBackInitState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formGK = GlobalKey<FormState>();
    return BlocProvider<TopicFormBloc>(
      create: (context) => TopicFormBloc(context),
      child: BlocBuilder<TopicFormBloc, TopicFormState>(
        builder: (context, state) {
          if (state is TopicFormSubmitSuccess) {
            callBackInitState();
            Navigator.pop(context);
          }
          Topic topicData = context.read<TopicFormBloc>().topic!;
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Container(
                // width: MediaQuery.of(context).size.width,
                child: Form(
                  key: _formGK,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // LinearProgressIndicator(value: _formProgress),
                                // Text('', style: Theme.of(context).textTheme.headline4),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    // controller: _firstNameTextController,
                                    decoration:
                                        InputDecoration(hintText: 'ชื่อกระทู้'),
                                    onChanged: (value) =>
                                        topicData.topicTitle = value,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    // controller: _usernameTextController,
                                    decoration: InputDecoration(
                                        hintText: 'เนื้อหาของกระทู้'),
                                    maxLines: 20,
                                    onChanged: (value) =>
                                        topicData.topicDetail = value,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            color: Colors.blueGrey[200],
                            width: 1,
                          ),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              onPressed: () async {},
                              icon: Icon(Icons.image),
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () => context
                            .read<TopicFormBloc>()
                            .add(TopicFormSubmitted()),
                        child: Text('บันทึกข้อมูล'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
