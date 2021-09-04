import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_knowledgebase/models/models.dart';

class CategoryServices {
  static final collectionName = "categories";

  Future<List<Category>> readCategories() async {
    var result = await FirebaseFirestore.instance
        .collection(collectionName)
        .get()
        .catchError((e) {
      print('read categories error -> $e');
    });

    return result.docs.isNotEmpty
        ? result.docs
            .map((category) =>
                Category.fromJson(category.data()..addAll({'id': category.id})))
            .toList()
        : [];
  }
}
