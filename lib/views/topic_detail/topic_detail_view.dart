import 'package:community_knowledgebase/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'bloc/topic_detail_bloc.dart';

class TopicDetailView extends StatefulWidget {
  final Topic topic;
  TopicDetailView(this.topic, {Key? key}) : super(key: key);

  @override
  _TopicDetailViewState createState() => _TopicDetailViewState();
}

class _TopicDetailViewState extends State<TopicDetailView> {
  final _textCommentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
      ),
      body: BlocProvider<TopicDetailBloc>(
        create: (context) => TopicDetailBloc(context, widget.topic),
        child: BlocBuilder<TopicDetailBloc, TopicDetailState>(
          builder: (context, state) {
            _textCommentController.clear();
            List<Comment> _comments = context.read<TopicDetailBloc>().comments;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Card(
                      color: Colors.grey[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 8,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              widget.topic.topicTitle ?? '',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Divider(),
                          ),
                          ListTile(
                            leading: Icon(Icons.people),
                            title: Text(
                              widget.topic.member?.memberDisplayname ?? '',
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6)),
                            ),
                            subtitle: Text(
                              'วันที่ 04-08-2021',
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Center(
                      child: Column(
                        children: List.generate(
                          _comments.length,
                          (index) {
                            var date = DateTime.fromMicrosecondsSinceEpoch(
                                _comments[index]
                                    .createDate!
                                    .millisecondsSinceEpoch);
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Card(
                                  color: Colors.grey[200],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  elevation: 8,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(
                                          _comments[index].comment ?? '',
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Divider(),
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.people),
                                        title: Text(
                                          _comments[index]
                                                  .member
                                                  ?.memberDisplayname ??
                                              '',
                                          style: TextStyle(
                                              color: Colors.black
                                                  .withOpacity(0.6)),
                                        ),
                                        subtitle: Text(
                                          '${DateFormat('dd/MM/yyy').format(date)}',
                                          style: TextStyle(
                                              color: Colors.black
                                                  .withOpacity(0.6)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _textCommentController,
                              ),
                            )),
                            const SizedBox(width: 8),
                            TextButton(
                              child: const Text('แสดงความคิดเห็น'),
                              onPressed: () => context
                                  .read<TopicDetailBloc>()
                                  .add(TopicAddedComment(
                                      _textCommentController.text)),
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
