import 'package:community_knowledgebase/models/models.dart';
import 'package:community_knowledgebase/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [firstColor, secondColor],
                stops: [0.5, 1.0],
              ),
            ),
          ),
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
                      subtitle: Text(
                          'วันที่ ${DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(knowledgeDetail.timestamp!.millisecondsSinceEpoch))}'),
                      isThreeLine: true,
                    ),
                  ),
                  SizedBox(height: 24),
                  Container(
                    height: MediaQuery.of(context).size.width / 5,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: knowledgeDetail.images.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(
                          knowledgeDetail.images[index],
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: Text(
                      'อำเภอ : ${knowledgeDetail.address?.subDistrict?.name ?? ''}',
                      style: TextStyle(fontSize: 16),
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
