import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_knowledgebase/models/member.dart';

class Comment {
  String? id;
  String? comment;
  Member? member;
  Timestamp? createDate;

  Comment({
    required this.comment,
    required this.member,
    this.createDate,
  });

  Comment.fromJson(dynamic json)
      : comment = json['comment'] != null ? json['comment'] : '',
        createDate = json['create_date'] != null ? json['create_date'] : null,
        member = json['member'] != null
            ? Member.fromMinimalJson(json['member'])
            : null;

  Map<String, dynamic> toJson() => {
        'comment': comment ?? '',
        'create_date': createDate ?? Timestamp.now(),
        if (member != null) 'member': member!.toMinimalJson()
      };
}
