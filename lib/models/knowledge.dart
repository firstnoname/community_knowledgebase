import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_knowledgebase/models/category.dart';
import 'package:community_knowledgebase/models/models.dart';

class Knowledge {
  String? knowledgeId;
  String? knowledgeTitle;
  String? knowledgeDesciption;
  String? knowledgeContent;
  Category? category;
  Clip? clip;
  List<String> images;
  Member? member;
  String? status;
  Timestamp? timestamp;
  Address? address;
  int views;

  Knowledge({
    this.knowledgeId,
    this.knowledgeTitle,
    this.knowledgeDesciption,
    this.knowledgeContent,
    this.category,
    this.clip,
    required this.images,
    this.member,
    this.status,
    this.timestamp,
    this.address,
    this.views = 0,
  });

  Knowledge.fromJson(dynamic json)
      : knowledgeId = json['id'],
        knowledgeTitle = json['knowledge_title'],
        knowledgeDesciption = json['knowledge_description'],
        knowledgeContent = json['knowledge_content'],
        category = json['category'] != null
            ? Category.fromJson(json['category'])
            : null,
        clip = json['clip'] != null ? Clip.fromJson(json['clip']) : null,
        member = json['member'] != null
            ? Member.fromMinimalJson(json['member'])
            : null,
        images = json['images'] != null ? json['images'].cast<String>() : [],
        status = json['status'],
        timestamp = json['timestamp'],
        address =
            json['address'] != null ? Address.fromJson(json['address']) : null,
        views = json['views'] ?? 0;

  Map<String, dynamic> toJson() => {
        'knowledge_title': knowledgeTitle ?? '',
        'knowledge_description': knowledgeDesciption ?? '',
        'knowledge_content': knowledgeContent ?? '',
        if (category != null) 'category': category!.toJson(),
        if (clip != null) 'clip': clip!.toJson(),
        if (member != null) 'member': member!.toMinimalJson(),
        'images': images,
        'status': status ?? 'รออนุมัติ',
        'timestamp': timestamp ?? Timestamp.now(),
        'address': address != null ? address!.toJson() : null,
        'views': views,
      };
}

class KnowledgeStatus {
  static const pending = 'รออนุมัติ';
  static const accepted = 'อนุมัติ';
  static const deleted = 'ลบแล้ว';
  static const rejected = 'ไม่แสดง';
}
