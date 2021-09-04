import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_knowledgebase/models/member.dart';

class Topic {
  String? topicId;
  String? topicTitle;
  String? topicDetail;
  Timestamp? createDate;
  Member? member;

  Topic({
    this.topicId,
    this.topicTitle,
    this.topicDetail,
    this.createDate,
    this.member,
  });

  factory Topic.fromJson(dynamic json) {
    var topicObject = Topic();
    topicObject.topicId = json['id'];
    topicObject.topicTitle = json['topic_title'];
    topicObject.topicDetail = json['topic_detail'];
    topicObject.createDate =
        json["create_date"] != null ? json["create_date"] : null;
    topicObject.member =
        json['member'] != null ? Member.fromJson(json['member']) : null;
    return topicObject;
  }

  Map<String, dynamic> toJson() => {
        'topic_title': topicTitle ?? '',
        'topic_detail': topicDetail ?? '',
        'create_date': createDate ?? '',
        if (member != null) 'member': member!.toJson(),
      };
}
