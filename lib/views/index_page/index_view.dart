import '../../models/models.dart';
import '../../views/index_page/bloc/index_bloc.dart';
import '../../views/topic_list/topic_list_view.dart';
import '../../views/views.dart';
import '../../widgets/widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IndexView extends StatelessWidget {
  IndexView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.width * 0.08;
    var _width = MediaQuery.of(context).size.width * 0.3;

    return BlocProvider<IndexBloc>(
      create: (context) => IndexBloc(context),
      child: BlocBuilder<IndexBloc, IndexState>(
        builder: (context, state) {
          Member member = context.read<IndexBloc>().member;
          List<Category> categories =
              context.read<IndexBloc>().appManagerBloc.categoreis;
          List<Announcement> announcementList =
              context.read<IndexBloc>().announcementList;
          return Scaffold(
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    child: Image.asset(
                      'assets/images/camt_horizontal.jpg',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text('คลังความรู้ชุมชน'),
                ],
              ),
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
              child: SingleChildScrollView(
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
                    SizedBox(height: 36),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: GridView.count(
                        crossAxisCount: 3,
                        // crossAxisCount: MediaQuery.of(context).size.width <=
                        //         400.0
                        //     ? 3
                        //     : MediaQuery.of(context).size.width >= 1000.0
                        //         ? 5
                        //         : 4,
                        childAspectRatio: 3,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: List.generate(
                          categories.length,
                          (index) {
                            return FittedBox(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: _height,
                                  width: _width,
                                  child: ElevatedButton(
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => KnowledgeListView(
                                          title:
                                              '${categories[index].categoryName}',
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '${categories[index].categoryName}',
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width <=
                                                  400.0
                                              ? 4
                                              : MediaQuery.of(context)
                                                          .size
                                                          .width >=
                                                      1000.0
                                                  ? 20
                                                  : 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
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
                                      content: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(announcement.content),
                                            announcement.image != null
                                                ? Image.network(
                                                    announcement.image!,
                                                    fit: BoxFit.contain,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            5,
                                                    width:
                                                        MediaQuery.of(context)
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
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
