import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_knowledgebase/models/topic.dart';

class TopicServices {
  Future<List<Topic>> readTopics() async {
    List<Topic> topics = [];

    await FirebaseFirestore.instance.collection('topics').get().then((value) {
      topics = value.docs
          .map((e) => Topic.fromJson(e.data()..addAll({'id': e.id})))
          .toList();
    }).catchError((e) => print('topics error -> $e'));

    return topics;
  }

  Future<Topic> addTopic(Topic topic) async {
    CollectionReference topicCollection =
        FirebaseFirestore.instance.collection('topics');
    return topicCollection.add(topic.toJson()).then((value) {
      topic.topicId = value.id;
      return topic;
    }).catchError((e) {
      print('Add topic failed -> $e');
    });
  }
}
