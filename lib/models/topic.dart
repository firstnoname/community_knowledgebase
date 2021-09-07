import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:community_knowledgebase/models/models.dart';

class Topic {
  String? topicId;
  String? topicTitle;
  String? topicDetail;
  Timestamp? createDate;
  Member? member;
  Comment? comment;

  Topic({
    this.topicId,
    this.topicTitle,
    this.topicDetail,
    this.createDate,
    this.member,
    this.comment,
  });

  factory Topic.fromJson(dynamic json) {
    var topicObject = Topic();
    topicObject.topicId = json['id'];
    topicObject.topicTitle = json['topic_title'];
    topicObject.topicDetail = json['topic_detail'];
    topicObject.createDate =
        json["create_date"] != null ? json["create_date"] : null;
    topicObject.member =
        json['member'] != null ? Member.fromMinimalJson(json['member']) : null;
    topicObject.comment =
        json['comments'] != null ? Comment.fromJson(json['comments']) : null;
    return topicObject;
  }

  Map<String, dynamic> toJson() => {
        'topic_title': topicTitle ?? '',
        'topic_detail': topicDetail ?? '',
        'create_date': createDate ?? Timestamp.now(),
        if (member != null) 'member': member!.toMinimalJson(),
      };
}
