import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_knowledgebase/models/models.dart';
import 'package:community_knowledgebase/services/topic_services.dart';

class CommentServices {
  static const collectionComment = 'comments';

  Future<List<Comment>> readComment(String topicId) async {
    List<Comment> _comments = [];

    await FirebaseFirestore.instance
        .collection(TopicServices.collectionTopic)
        .doc(topicId)
        .collection(collectionComment)
        .get()
        .then((value) {
      _comments = value.docs
          .map((e) => Comment.fromJson(e.data()..addAll({'id': e.id})))
          .toList();
      // value.docs.forEach((element) {
      //   _comments
      //       .add(Comment.fromJson(element.data()..addAll({'id': element.id})));
      // });
    });

    return _comments;
  }

  Future<Comment?> addComment(String topicId, Comment comment) async {
    var result = await FirebaseFirestore.instance
        .collection(TopicServices.collectionTopic)
        .doc(topicId)
        .collection(collectionComment)
        .add(comment.toJson())
        .then((value) {
      comment.id = value.id;
    }).catchError((e) {
      print('add comment failed -> $e');
    });
    // print('result -> ${result.snapshots()}');
    return comment;
  }

  Future<bool> deleteComment(
      {required String topicId, required String commentId}) async {
    bool isSucess = true;
    await FirebaseFirestore.instance
        .collection(TopicServices.collectionTopic)
        .doc(topicId)
        .collection(collectionComment)
        .doc(commentId)
        .delete()
        .catchError((error) {
      isSucess = false;
      print('delete comment failure -> ${error.toString()}');
    });

    return isSucess;
  }
}
