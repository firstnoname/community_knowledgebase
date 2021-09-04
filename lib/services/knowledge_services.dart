import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_knowledgebase/models/knowledge.dart';
import 'package:community_knowledgebase/services/services.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';

class KnowledgeServices {
  static final collectionName = "knowledgebase";
  // -----------------------------  Firebase  --------------------------------- //
  Future<String> acceptKnowledge(String knolwedgeId) async {
    await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(knolwedgeId)
        .update({'status': 'อนุมัติ'});

    return knolwedgeId;
  }

  Future<String> rejectKnowledge(String knolwedgeId) async {
    await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(knolwedgeId)
        .update({'status': 'ยกเลิก'});

    return knolwedgeId;
  }

  Future<List<Knowledge>> readKnowledgeList(
      {String? status, String? categoryName}) async {
    List<Knowledge> knowledgeList = [];
    print('status -> $status');
    await FirebaseFirestore.instance
        .collection('knowledgebase')
        .where('status', isEqualTo: status)
        .where('category.category_name', isEqualTo: categoryName)
        .get()
        .then((value) {
      print('docs value -> ${value.docs.length}');
      knowledgeList = value.docs
          .map((item) =>
              Knowledge.fromJson(item.data()..addAll({'id': item.id})))
          .toList();
    }).catchError((e) {});
    return knowledgeList;
  }

  Future<Knowledge> addKnowledge(Knowledge knowledge, {List<File>? pictures}) {
    CollectionReference knowledgebaseCollection =
        FirebaseFirestore.instance.collection('knowledgebase');
    return knowledgebaseCollection.add(knowledge.toJson()).then((value) {
      knowledge.knowledgeId = value.id;
      return knowledge;
    }).catchError((e) {
      print('Add knowledge failed -> $e');
    });
  }

  Future<String> uploadImageAsset(File pictures, String path, String fileName,
      {int quality = 50}) async {
    // Uint8List image =
    //     (await asset.getByteData(quality: quality)).buffer.asUint8List();
    Uint8List? image;

    var ref = FirebaseStorage.instance.ref(path);
    var uploadTask = ref.child(fileName).putData(image!);
    return await (await uploadTask).ref.getDownloadURL();
  }

  // -----------------------------  MySQL  --------------------------------- //
  static Future<Null> addKnowledgeSQL() async {
    return null;
  }

  static Future<Null> readKnowledgeSQL() async {
    String url = '${Services.url}knowledgebase_read.php';
    String cors = 'https://cors-anywhere.herokuapp.com/';
    String testUrl = '${cors}https://api.publicapis.org/entries';
    try {
      final response = await Dio().post(
        url,
        options: Options(
          headers: {
            "Accept": "application/json",
            "Access-Control-Allow-Origin": "Access-Control-Allow-Origin, Accept"
          },
        ),
      );
      print('read knowledge response -> $response');
    } on DioError catch (e) {
      throw ('read knowledge error -> ${e.message}');
    }
    return null;
  }
}
