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
  List<String>? images;
  Member? member;
  String? status;
  Timestamp? timestamp;

  Knowledge({
    this.knowledgeId,
    this.knowledgeTitle,
    this.knowledgeDesciption,
    this.knowledgeContent,
    this.category,
    this.clip,
    this.images,
    this.member,
    this.status,
    this.timestamp,
  });

  factory Knowledge.fromJson(dynamic json) {
    var knowledgeObject = Knowledge();
    knowledgeObject.knowledgeId = json['id'];
    knowledgeObject.knowledgeTitle = json['knowledge_title'];
    knowledgeObject.knowledgeDesciption = json['knowledge_description'];
    knowledgeObject.knowledgeContent = json['knowledge_content'];
    knowledgeObject.category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
    knowledgeObject.clip =
        json['clip'] != null ? Clip.fromJson(json['clip']) : null;
    knowledgeObject.member =
        json['member'] != null ? Member.fromMinimalJson(json['member']) : null;
    knowledgeObject.images =
        json['images'] != null ? json['images'].cast<String>() : [];
    knowledgeObject.status = json['status'];
    knowledgeObject.timestamp = json['timestamp'];
    return knowledgeObject;
  }

  Map<String, dynamic> toJson() => {
        'knowledge_title': knowledgeTitle ?? '',
        'knowledge_description': knowledgeDesciption ?? '',
        'knowledge_content': knowledgeContent ?? '',
        if (category != null) 'category': category!.toJson(),
        if (clip != null) 'clip': clip!.toJson(),
        if (member != null) 'member': member!.toMinimalJson(),
        'images': images ?? [],
        'status': status ?? 'รออนุมัติ',
        'timestamp': timestamp ?? Timestamp.now(),
      };
}

class KnowledgeStatus {
  static const pending = 'รออนุมัติ';
  static const accepted = 'อนุมัติ';
  static const deleted = 'ลบแล้ว';
  static const rejected = 'ไม่แสดง';
}
