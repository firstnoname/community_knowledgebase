import 'package:community_knowledgebase/models/models.dart';
import 'package:community_knowledgebase/views/knowledge_detail/knowledge_detail_view.dart';
import 'package:community_knowledgebase/views/verification_page/bloc/verification_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Search extends SearchDelegate {
  Knowledge? selectedResult;
  final List<Knowledge> list;
  Search(this.list);

  List<Knowledge> recentList = [];

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Center(
        child: Text(selectedResult!.knowledgeTitle!),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Knowledge> suggestionList = [];
    query.isEmpty
        ? suggestionList = recentList
        : suggestionList.addAll(list.where(
            (element) => element.knowledgeTitle!.contains(query),
          ));

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestionList[index].knowledgeTitle!),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => KnowledgeDetailView(
                      suggestionList[index],
                      () => BlocProvider.of<VerificationBloc>(context)
                          .add(VerficationInitial())),
                ));
            // selectedResult = suggestionList[index];
            // showResults(context);
          },
        );
      },
    );
  }
}
