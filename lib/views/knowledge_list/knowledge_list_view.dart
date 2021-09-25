import 'package:community_knowledgebase/models/knowledge.dart';
import 'package:community_knowledgebase/views/knowledge_form/knowledge_form_view.dart';
import 'package:community_knowledgebase/views/knowledge_list/bloc/knowledge_list_bloc.dart';
import 'package:community_knowledgebase/views/views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class KnowledgeListView extends StatefulWidget {
  final String title;
  const KnowledgeListView({required this.title, Key? key}) : super(key: key);

  @override
  _KnowledgeListViewState createState() => _KnowledgeListViewState();
}

class _KnowledgeListViewState extends State<KnowledgeListView> {
  int _value = 0;
  List<String> _filters = ['ทั้งหมด', 'ยอดนิยม'];
  List<Knowledge> knowledgeList = [];

  // DateFormat dateFormat = DateFormat.yMMMd('th');

  @override
  Widget build(BuildContext context) {
    return BlocProvider<KnowledgeListBloc>(
      create: (context) => KnowledgeListBloc(context, widget.title),
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
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: List<Widget>.generate(
                        2,
                        (int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 8),
                            child: ChoiceChip(
                              label: Text('${_filters[index]}'),
                              selected: _value == index,
                              onSelected: (bool selected) {
                                context.read<KnowledgeListBloc>().add(
                                    KnowledgeListEventChangedSortBy(index));
                                _value = (selected ? index : null)!;
                              },
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: knowledgeList.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => KnowledgeDetailView(
                                knowledgeList[index], () {}),
                          )),
                      child: Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.album),
                              title: Text(
                                  '${knowledgeList[index].knowledgeTitle}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      '${knowledgeList[index].knowledgeDesciption}'),
                                  SizedBox(height: 8),
                                  Text(
                                      'จำนวนผู้ชม ${knowledgeList[index].views}'),
                                ],
                              ),
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
