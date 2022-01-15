import 'package:community_knowledgebase/models/models.dart';
import 'package:community_knowledgebase/utilities/app_themes.dart';
import 'package:flutter/material.dart';

class AnnouncementCard extends StatelessWidget {
  final Announcement announcement;
  AnnouncementCard({Key? key, required this.announcement}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width / 6;
    var height = MediaQuery.of(context).size.width / 7;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: width,
        height: height,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                announcement.images!.first != null
                    ? Expanded(
                        flex: 3,
                        child: Image.network(
                          announcement.images!.first,
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                        ),
                      )
                    : Container(),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(child: Text('${announcement.title}')),
                        Text(
                          'อ่านต่อ',
                          style: TextStyle(color: primaryColor),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
