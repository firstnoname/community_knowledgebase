class Category {
  String? categoryId;
  String? categoryDesc;
  String? categoryName;

  Category({
    this.categoryId,
    this.categoryDesc,
    this.categoryName,
  });

  factory Category.fromJson(dynamic json) => Category(
        // categoryId: json['category_id'],
        categoryName: json['category_name'],
        categoryDesc: json['category_description'],
      );

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{
      // 'category_id': categoryId,
      'category_name': categoryName ?? '',
      'category_description': categoryDesc ?? '',
    };
    return map;
  }
}
