import 'package:community_knowledgebase/bloc/blocs/app_manager_bloc.dart';
import 'package:community_knowledgebase/services/user_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserAuth {
  final AppManagerBloc _appManagerBloc;
  static UserAuth? _cache;
  final FirebaseAuth _firebaseAuth;

  User? get firebaseCurrentUser => _firebaseAuth.currentUser;

  factory UserAuth(AppManagerBloc appManagerBloc) {
    if (_cache == null) _cache = UserAuth._(appManagerBloc);
    return _cache!;
  }

  UserAuth._(this._appManagerBloc) : _firebaseAuth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  bool isLoggedIn() {
    return _firebaseAuth.currentUser != null;
  }

  Future<UserCredential> signInWithEmail(String email, String pass) async {
    var userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: pass);
    await checkCurrentUserProfile();
    return userCredential;
  }

  Future signUpWithEmail(String email, String pass, String displayName) async {
    try {
      UserCredential result = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: pass);
      User user = result.user!;
      await user.updateDisplayName(displayName).then((value) {
        print('user -> ${user.displayName}');
      }).catchError((e) {
        print('add displayname error -> $e');
      });

      return user;
    } on FirebaseAuthException catch (e) {
      print('Signup failed -> ${e.message}');
    }
  }

  Future<void> signOut() => _firebaseAuth
      .signOut()
      .then((value) => print('Log out success'))
      .catchError((e) => print('Error occurred: ${e.toString()}'));

  checkCurrentUserProfile() async {
    var user = _firebaseAuth.currentUser;
    var member = await UserServices().getUser(_firebaseAuth.currentUser!.uid);
    if (user != null) {
      _appManagerBloc.registerState = true;
      _appManagerBloc.updateCurrentUserProfile(user, member);
    }

    _appManagerBloc.add(AppManagerLoginSuccessed());
  }
}
