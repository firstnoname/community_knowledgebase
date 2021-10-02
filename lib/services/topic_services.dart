import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_knowledgebase/models/models.dart';
import 'package:community_knowledgebase/models/topic.dart';

class TopicServices {
  static const collectionTopic = 'topics';

  Future<List<Topic>> readTopics() async {
    List<Topic> topics = [];

    await FirebaseFirestore.instance
        .collection(collectionTopic)
        .get()
        .then((value) {
      topics = value.docs
          .map((e) => Topic.fromJson(e.data()..addAll({'id': e.id})))
          .toList();
    }).catchError((e) => print('topics error -> $e'));

    return topics;
  }

  Future<Topic?> addTopic(Topic topic) async {
    CollectionReference topicCollection =
        FirebaseFirestore.instance.collection(collectionTopic);
    return topicCollection.add(topic.toJson()).then((value) {
      topic.topicId = value.id;
      return topic;
    }).catchError((e) {
      print('Add topic failed -> $e');
      return null;
    });
  }

  Future<bool> deleteTopic(String topicId) async {
    bool isSuccess = true;

    try {
      await FirebaseFirestore.instance
          .collection(collectionTopic)
          .doc(topicId)
          .delete();
    } on Exception catch (e) {
      isSuccess = false;
      print('delete topic failure -> ${e.toString()}');
    }

    return isSuccess;
  }
}
