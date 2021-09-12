import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_knowledgebase/models/announcement.dart';
import 'package:community_knowledgebase/services/image_services.dart';
import 'package:image_picker_web/image_picker_web.dart';

class AnnouncementServices {
  static const collectionName = 'announcements';

  Future<bool> addAnnouncement(
      Announcement announcement, MediaInfo? image) async {
    bool _isSuccess = false;
    var result = await FirebaseFirestore.instance
        .collection(collectionName)
        .add(announcement.toJson())
        .then((value) {
      announcement.id = value.id;
      return value;
    }).catchError((e) {
      print('add comment failed -> $e');
    });

    if (result.id.isNotEmpty) {
      _isSuccess = true;

      var path = "announcements_image/${result.id}";
      if (image != null) {
        announcement.image =
            await ImageServices().uploadFile(image.data!, path);
        // update announcement in firebase.
        await FirebaseFirestore.instance
            .collection(collectionName)
            .doc(announcement.id)
            .update({'image': announcement.image});
      }
    }

    return _isSuccess;
  }

  Future<List<Announcement>> readAnnouncementList() async {
    List<Announcement> announcementList = [];

    await FirebaseFirestore.instance
        .collection(collectionName)
        .get()
        .then((value) {
      print('docs value -> ${value.docs.length}');
      announcementList = value.docs
          .map((item) =>
              Announcement.fromJson(item.data()..addAll({'id': item.id})))
          .toList();
    }).catchError((e) {
      print('Read annoucement failed -> ${e.toString()}');
    });
    return announcementList;
  }
}
