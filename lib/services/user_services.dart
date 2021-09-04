import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_knowledgebase/bloc/blocs/app_manager_bloc.dart';
import 'package:community_knowledgebase/models/models.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserServices {
  static final collectionName = "members";

  Future<Member?> getUser(String? id) async {
    var snapshot = await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(id)
        .get();
    return (!snapshot.exists)
        ? null
        : Member.fromJson(
            snapshot.data()!..addAll({'member_id': id}),
          );
  }

  Future<Member> addUser(User userInfo, String displayName) async {
    Member member = Member(
      memberDisplayname: displayName,
      memberEmail: userInfo.email,
      memberStatus: 'user',
      memberFirsname: '',
      memberLastname: '',

      // TODO here เพิ่ม user ไป collection แล้วกำหนด user role.
    );

    try {
      print('user id -> ${userInfo.uid}');
      await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(userInfo.uid)
          .set(member.toJson())
          .then((value) => print('Add member success.'))
          .catchError((e) => print('Add member failed -> $e'));
    } on FirebaseException catch (e) {
      print('add member failed -> ${e.message}');
    }
    return member;
  }
}
