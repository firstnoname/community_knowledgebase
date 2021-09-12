import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_knowledgebase/models/member.dart';

class Announcement {
  String? id;
  String title;
  String content;
  Member member;
  Timestamp? createDate;
  String? image;

  Announcement({
    this.id,
    required this.title,
    required this.content,
    required this.member,
    required this.createDate,
    this.image,
  });

  factory Announcement.fromJson(dynamic json) => Announcement(
        title: json['title'],
        content: json['content'],
        member: Member.fromMinimalJson(json['member']),
        createDate: json['createDate'] ?? null,
        image: json['image'] ?? null,
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        'member': member.toMinimalJson(),
        'create_date': createDate,
        'image': image,
      };
}
