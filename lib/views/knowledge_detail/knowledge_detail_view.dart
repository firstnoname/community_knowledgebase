import 'package:community_knowledgebase/models/models.dart';
import 'package:community_knowledgebase/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

import 'bloc/knowledge_detail_bloc.dart';

class KnowledgeDetailView extends StatefulWidget {
  final Knowledge knowledgeDetail;
  final Function callBackInitialFunction;
  const KnowledgeDetailView(this.knowledgeDetail, this.callBackInitialFunction,
      {Key? key})
      : super(key: key);

  @override
  State<KnowledgeDetailView> createState() => _KnowledgeDetailViewState();
}

class _KnowledgeDetailViewState extends State<KnowledgeDetailView> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    if (widget.knowledgeDetail.videoPath != null) {
      _videoController =
          VideoPlayerController.network(widget.knowledgeDetail.videoPath!)
            ..initialize().then((_) => setState(() {}));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<KnowledgeDetailBloc>(
      create: (context) => KnowledgeDetailBloc(context, widget.knowledgeDetail),
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
                  widget.callBackInitialFunction();
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
                            child: ElevatedButton(
                              child: Text(
                                'ยืนยันการเผยแพร่ข้อมูล',
                                style: TextStyle(color: Colors.blue),
                              ),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white)),
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
                            child: ElevatedButton(
                              child: Text(
                                'ข้อมูลไม่สมบูรณ์',
                                style: TextStyle(
                                  color: Colors.redAccent,
                                ),
                              ),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white)),
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
                    widget.knowledgeDetail.knowledgeTitle!,
                    style: TextStyle(fontSize: 36),
                  ),
                  SizedBox(height: 16),
                  Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.people),
                      ),
                      title: Text(
                          widget.knowledgeDetail.member!.memberDisplayname!),
                      subtitle: Text(
                          'วันที่ ${DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(widget.knowledgeDetail.timestamp!.millisecondsSinceEpoch))}'),
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
                      itemCount: widget.knowledgeDetail.images.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(
                          widget.knowledgeDetail.images[index],
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  _videoController.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: _videoController.value.aspectRatio,
                          child: Stack(
                            children: [
                              VideoPlayer(_videoController),
                              Container(
                                width: double.infinity,
                                height: double.infinity,
                                color: Colors.transparent,
                                child: IconButton(
                                  icon: _videoController.value.isPlaying
                                      ? Icon(
                                          Icons.pause,
                                          color: Colors.transparent,
                                        )
                                      : CircleAvatar(
                                          backgroundColor:
                                              Colors.grey.withOpacity(0.8),
                                          foregroundColor: Colors.white,
                                          child: Icon(
                                            Icons.play_arrow,
                                            size: 24,
                                          ),
                                        ),
                                  onPressed: () => setState(() {
                                    _videoController.value.isPlaying
                                        ? _videoController.pause()
                                        : _videoController.play();
                                  }),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: Text(
                      'อำเภอ : ${widget.knowledgeDetail.address?.subDistrict?.name ?? ''}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: Text(
                      widget.knowledgeDetail.knowledgeContent!,
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
