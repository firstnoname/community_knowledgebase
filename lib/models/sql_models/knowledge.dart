class KnowledgeSQL {
  String? knowledgeId;
  String? knowledgeTitle;
  String? knowledgeDesc;
  String? contentDetail;
  String? memberId;
  String? categoryId;

  KnowledgeSQL(
      {this.knowledgeId,
      required this.knowledgeTitle,
      required this.knowledgeDesc,
      required this.contentDetail,
      required this.memberId,
      required this.categoryId});

  KnowledgeSQL.fromJson(Map<String, dynamic> json) {
    knowledgeId = json['knowledge_id'] ?? null;
    knowledgeTitle = json['knowledge_title'] ?? null;
    knowledgeDesc = json['knowledge_desc'] ?? null;
    contentDetail = json['content_detail'] ?? null;
    memberId = json['member_id'] ?? null;
    categoryId = json['category_id'] ?? null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['knowledge_id'] = this.knowledgeId;
    data['knowledge_title'] = this.knowledgeTitle;
    data['knowledge_desc'] = this.knowledgeDesc;
    data['content_detail'] = this.contentDetail;
    data['member_id'] = this.memberId;
    data['category_id'] = this.categoryId;
    return data;
  }
}
