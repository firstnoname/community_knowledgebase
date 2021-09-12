import 'package:community_knowledgebase/models/announcement.dart';
import 'package:community_knowledgebase/models/models.dart';
import 'package:community_knowledgebase/views/index_page/bloc/index_bloc.dart';
import 'package:community_knowledgebase/views/topic_list/topic_list_view.dart';
import 'package:community_knowledgebase/views/views.dart';
import 'package:community_knowledgebase/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IndexView extends StatelessWidget {
  const IndexView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height * 0.15;
    var _width = MediaQuery.of(context).size.width * 0.2;
    return BlocProvider<IndexBloc>(
      create: (context) => IndexBloc(context),
      child: BlocBuilder<IndexBloc, IndexState>(
        builder: (context, state) {
          Member member = context.read<IndexBloc>().member;
          List<Announcement> announcementList =
              context.read<IndexBloc>().announcementList;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'คลังความรู้ชุมชน',
            home: Scaffold(
              appBar: AppBar(
                title: Text('Logo คลังความรู้ชุมชน'),
                actions: [
                  member.memberStatus == 'admin'
                      ? ElevatedButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AnnouncementForm(),
                            ),
                          ),
                          child: Text('เพิ่มประกาศ'),
                        )
                      : Container(),
                  member.memberStatus == 'admin'
                      ? ElevatedButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VerificationView(),
                              )),
                          child: Text('จัดการองค์ความรู้'))
                      : Container(),
                  ElevatedButton(onPressed: () {}, child: Text('หน้าหลัก')),
                  ElevatedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TopicListView(),
                        )),
                    child: Text('ประเด็นสนทนา'),
                  ),
                  ElevatedButton(onPressed: () {}, child: Text('ติดต่อเรา')),
                  IconButton(
                    onPressed: () =>
                        context.read<IndexBloc>().add(LogoutPressed()),
                    icon: Icon(Icons.logout),
                  ),
                ],
              ),
              body: Container(
                color: Colors.grey[200],
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 36),
                      Text(
                        'คลังความรู้ชุมชน',
                        style: TextStyle(fontSize: 36),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'ร่วมแบ่งปันความรู้แก่สมาชิก',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 72),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: _height,
                            width: _width,
                            child: ElevatedButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => KnowledgeListView(
                                    title: 'ประเพณีและวัฒนธรรม',
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.window),
                                    Text('ประเพณีและวัฒนธรรม'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              height: _height,
                              width: _width,
                              child: ElevatedButton(
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => KnowledgeListView(
                                          title: 'สินค้าเศรษฐกิจ'),
                                    )),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.fiber_dvr),
                                      Text('สินค้าเศรษฐกิจ'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: _height,
                            width: _width,
                            child: ElevatedButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        KnowledgeListView(title: 'เกษตรกรรม'),
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.architecture),
                                    Text('เกษตรกรรม'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: announcementList
                              .map(
                                (announcement) => GestureDetector(
                                  child: AnnouncementCard(
                                      announcement: announcement),
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text(announcement.title),
                                      content: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(announcement.content),
                                          announcement.image != null
                                              ? Image.network(
                                                  announcement.image!,
                                                  fit: BoxFit.contain,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      5,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      5,
                                                )
                                              : Container(),
                                          ListTile(
                                            title: Text(
                                                'สร้างโดย : ${announcement.member.memberDisplayname}'),
                                            subtitle: Text(announcement
                                                    .createDate
                                                    ?.toDate()
                                                    .toString() ??
                                                ''),
                                          ),
                                        ],
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'OK'),
                                          child: const Text('ปิด'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
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
