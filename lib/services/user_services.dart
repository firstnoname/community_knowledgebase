import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<List<Member>> getUserList(String filterByName) async {
    List<Member> userList = [];

    await FirebaseFirestore.instance
        .collection(collectionName)
        .get()
        .then((value) {
      userList = value.docs
          .map((user) => Member.fromJson(user.data()..addAll({'id': user.id})))
          .toList();
    });

    return userList;
  }

  Future<Member> addUser(
      User userInfo, String displayName, Address address) async {
    Member member = Member(
      memberDisplayname: displayName,
      memberEmail: userInfo.email,
      memberStatus: 'user',
      memberFirsname: '',
      memberLastname: '',
      memberAddress: address,
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

  Future<bool> changeUserStatus(
      {required String userId, required bool isAdmin}) async {
    bool isSuccess = false;

    String userStatus = isAdmin == true ? 'admin' : 'user';

    try {
      await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(userId)
          .update({'member_status': userStatus}).then(
              (value) => isSuccess = true);
    } catch (e) {
      print('Change status failed');
    }

    return isSuccess;
  }
}
