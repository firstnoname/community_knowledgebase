import 'package:community_knowledgebase/models/models.dart';
import 'package:community_knowledgebase/utilities/constants.dart';
import 'package:community_knowledgebase/views/topic_list/bloc/topic_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'bloc/topic_detail_bloc.dart';

class TopicDetailView extends StatefulWidget {
  final Topic topic;
  final Function callBackInit;
  TopicDetailView(this.topic, {Key? key, required this.callBackInit})
      : super(key: key);

  @override
  _TopicDetailViewState createState() => _TopicDetailViewState();
}

class _TopicDetailViewState extends State<TopicDetailView> {
  final _textCommentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
        actions: [],
      ),
      body: BlocProvider<TopicDetailBloc>(
        create: (context) => TopicDetailBloc(context, widget.topic),
        child: BlocBuilder<TopicDetailBloc, TopicDetailState>(
          builder: (context, state) {
            _textCommentController.clear();
            List<Comment> _comments = context.read<TopicDetailBloc>().comments;
            Member member = context.read<TopicDetailBloc>().member;
            if (state is TopicDetailDeleteTopicSuccess) {
              Navigator.pop(context);
              widget.callBackInit();
            }

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
                      child: Stack(
                        children: [
                          member.memberStatus == 'admin'
                              ? Positioned(
                                  right: 4,
                                  top: 4,
                                  child: FittedBox(
                                    child: IconButton(
                                        onPressed: () {
                                          // delete topic
                                          context.read<TopicDetailBloc>().add(
                                              TopicDetailEventButtonDeleteTopicPressed(
                                                  widget.topic.topicId!));
                                        },
                                        icon: Icon(Icons.close)),
                                  ),
                                )
                              : Container(),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  widget.topic.topicTitle ?? '',
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  widget.topic.topicDetail ?? '',
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
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
                                  'วันที่ ${DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(widget.topic.createDate!.millisecondsSinceEpoch))}',
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.6)),
                                ),
                              ),
                            ],
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
                                  child: Stack(
                                    children: [
                                      member.memberStatus == 'admin'
                                          ? Positioned(
                                              right: 4,
                                              top: 4,
                                              child: FittedBox(
                                                child: IconButton(
                                                    onPressed: () {
                                                      // delete comment
                                                      context
                                                          .read<
                                                              TopicDetailBloc>()
                                                          .add(
                                                            TopicDetailEventButtonDeleteCommentPressed(
                                                                topicId: widget
                                                                    .topic
                                                                    .topicId!,
                                                                commentId:
                                                                    _comments[
                                                                            index]
                                                                        .id!),
                                                          );
                                                    },
                                                    icon: Icon(Icons.close)),
                                              ),
                                            )
                                          : Container(),
                                      Column(
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
