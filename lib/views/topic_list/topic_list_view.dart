import 'package:community_knowledgebase/models/models.dart';
import 'package:community_knowledgebase/utilities/constants.dart';
import 'package:community_knowledgebase/views/topic_list/bloc/topic_list_bloc.dart';
import 'package:community_knowledgebase/views/views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';

class TopicListView extends StatelessWidget {
  const TopicListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TopicListBloc>(
      create: (context) => TopicListBloc(context),
      child: BlocBuilder<TopicListBloc, TopicListState>(
        builder: (context, state) {
          List<Topic> topics = context.read<TopicListBloc>().topics;
          return Scaffold(
            appBar: AppBar(
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [firstColor, secondColor],
                    stops: [0.5, 1.0],
                  ),
                ),
              ),
              title: Text('กระทู้ทั้งหมด'),
              centerTitle: true,
              actions: [
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TopicFormView(
                        callBackInitState: () {
                          context.read<TopicListBloc>().add(TopicListInitial());
                        },
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        Text(
                          'สร้างกระทู้',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 7),
              child: ListView.builder(
                itemCount: topics.length,
                itemBuilder: (context, index) {
                  var date = DateTime.fromMicrosecondsSinceEpoch(
                      topics[index].createDate!.millisecondsSinceEpoch);

                  return GestureDetector(
                    child: Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.album),
                            title: Text('${topics[index].topicTitle}'),
                            subtitle: Text(
                              '${topics[index].topicDetail}',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                  'วันที่ ${DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(topics[index].createDate!.millisecondsSinceEpoch))}'),
                              const SizedBox(width: 8),
                              TextButton(
                                child: Text('อ่านต่อ ... '),
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TopicDetailView(
                                      topics[index],
                                      callBackInit: () {
                                        context
                                            .read<TopicListBloc>()
                                            .add(TopicListInitial());
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                        ],
                      ),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TopicDetailView(
                          topics[index],
                          callBackInit: () {
                            context
                                .read<TopicListBloc>()
                                .add(TopicListInitial());
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
