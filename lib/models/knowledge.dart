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
        json['member'] != null ? Member.fromJson(json['member']) : null;
    knowledgeObject.images =
        json['images'] != null ? json['images'].cast<String>() : [];
    knowledgeObject.status = json['status'];
    return knowledgeObject;
  }

  Map<String, dynamic> toJson() => {
        'knowledge_title': knowledgeTitle ?? '',
        'knowledge_description': knowledgeDesciption ?? '',
        'knowledge_content': knowledgeContent ?? '',
        if (category != null) 'category': category!.toJson(),
        if (clip != null) 'clip': clip!.toJson(),
        if (member != null) 'member': member!.toJson(),
        'images': images ?? [],
        'status': status ?? 'รออนุมัติ',
      };
}

class KnowledgeStatus {
  static const pending = 'รออนุมัติ';
  static const accepted = 'อนุมัติ';
  static const deleted = 'ลบแล้ว';
  static const rejected = 'ไม่แสดง';
}
