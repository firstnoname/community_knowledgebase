import 'package:community_knowledgebase/models/models.dart';
import 'package:community_knowledgebase/utilities/constants.dart';
import 'package:community_knowledgebase/utilities/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../views.dart';
import 'bloc/verification_bloc.dart';

class VerificationView extends StatefulWidget {
  VerificationView({Key? key}) : super(key: key);

  @override
  _VerificationViewState createState() => _VerificationViewState();
}

class _VerificationViewState extends State<VerificationView> {
  List<Knowledge> knowledgeList = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VerificationBloc>(
      create: (context) => VerificationBloc(context),
      child: BlocBuilder<VerificationBloc, VerificationState>(
        builder: (context, state) {
          knowledgeList = context.read<VerificationBloc>().knowledgeList;

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
              title: Text('จัดการองค์ความรู้ '),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () {
                    showSearch(
                        context: context, delegate: Search(knowledgeList));
                  },
                  icon: Icon(Icons.search),
                ),
              ],
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 7),
              child: ListView.builder(
                itemCount: knowledgeList.length,
                itemBuilder: (_, index) => GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => KnowledgeDetailView(
                          knowledgeList[index],
                          () {
                            context
                                .read<VerificationBloc>()
                                .add(VerficationInitial());
                          },
                        ),
                      )),
                  child: Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.album),
                          title: Text('${knowledgeList[index].knowledgeTitle}'),
                          subtitle: Text(
                              '${knowledgeList[index].knowledgeDesciption}'),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            TextButton(
                              child: Text(
                                  'วันที่ ${DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(knowledgeList[index].timestamp!.millisecondsSinceEpoch))}'),
                              onPressed: () {/* ... */},
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              child: const Text('อ่านต่อ ...'),
                              onPressed: () {/* ... */},
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ],
                    ),
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
