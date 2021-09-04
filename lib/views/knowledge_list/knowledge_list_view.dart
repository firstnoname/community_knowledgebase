import 'package:community_knowledgebase/models/knowledge.dart';
import 'package:community_knowledgebase/views/knowledge_form/knowledge_form_view.dart';
import 'package:community_knowledgebase/views/knowledge_list/bloc/knowledge_list_bloc.dart';
import 'package:community_knowledgebase/views/views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KnowledgeListView extends StatelessWidget {
  final String title;
  const KnowledgeListView({required this.title, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Knowledge> knowledgeList = [];
    return BlocProvider<KnowledgeListBloc>(
      create: (context) => KnowledgeListBloc(context, title),
      child: BlocBuilder<KnowledgeListBloc, KnowledgeListState>(
        builder: (context, state) {
          knowledgeList = context.read<KnowledgeListBloc>().knowledgeList;

          return Scaffold(
            appBar: AppBar(
              title: Text('องค์ความรู้'),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => KnowledgeFormView(title: ''),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Icon(Icons.add),
                        Text('สร้างองค์ความรู้'),
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
                itemCount: knowledgeList.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            KnowledgeDetailView(knowledgeList[index], () {}),
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
                              child: const Text('วันที่ 20-08-2021'),
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
