import 'package:community_knowledgebase/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/knowledge_detail_bloc.dart';

class KnowledgeDetailView extends StatelessWidget {
  final Knowledge knowledgeDetail;
  final Function callBackInitialFunction;
  const KnowledgeDetailView(this.knowledgeDetail, this.callBackInitialFunction,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<KnowledgeDetailBloc>(
      create: (context) => KnowledgeDetailBloc(context, knowledgeDetail),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            BlocBuilder<KnowledgeDetailBloc, KnowledgeDetailState>(
              buildWhen: (previous, current) {
                if (current is KnowledgeAcceptSuccess ||
                    current is KnowledgeEjectSuccess) {
                  callBackInitialFunction();
                  Navigator.pop(context);
                  return false;
                }
                return true;
              },
              builder: (context, state) {
                Member member = context.read<KnowledgeDetailBloc>().member;
                return member.memberStatus == 'admin'
                    ? Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: IconButton(
                              icon: Icon(
                                Icons.check,
                              ),
                              onPressed: () =>
                                  context.read<KnowledgeDetailBloc>().add(
                                        KnowledgeAccepted(),
                                      ),
                            ),
                          ),
                          Container(
                            width: 1,
                            color: Colors.grey,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: IconButton(
                              icon: Icon(
                                Icons.cancel,
                              ),
                              onPressed: () => context
                                  .read<KnowledgeDetailBloc>()
                                  .add(KnowledgeEjected()),
                            ),
                          ),
                        ],
                      )
                    : Container();
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width / 1.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Text(
                    knowledgeDetail.knowledgeTitle!,
                    style: TextStyle(fontSize: 36),
                  ),
                  SizedBox(height: 16),
                  Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.people),
                      ),
                      title: Text(knowledgeDetail.member!.memberDisplayname!),
                      subtitle: Text('วันที่ 20-08-2021'),
                      isThreeLine: true,
                    ),
                  ),
                  SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: knowledgeDetail.images
                          .map((image) => Image.network(
                                image,
                                fit: BoxFit.contain,
                                height: MediaQuery.of(context).size.width / 5,
                                width: MediaQuery.of(context).size.width / 5,
                              ))
                          .toList(),
                    ),
                  ),
                  SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: Text(
                      knowledgeDetail.knowledgeContent!,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
