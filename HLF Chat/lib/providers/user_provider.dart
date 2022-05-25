import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hlfchat/models/user.dart';
import 'package:hlfchat/screens/signin.dart';
import 'package:hlfchat/screens/signup.dart';
import 'package:provider/provider.dart';

import '../screens/home.dart';

class UserProvider with ChangeNotifier {
  late User user;
  bool isLoading = false;
  List<UserModel> otherUsers = [];

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool getAuthState() {
    if (FirebaseAuth.instance.currentUser != null) {
      return true;
    } else {
      return false;
    }
  }

  getData() {
    final box = GetStorage();
    user = FirebaseAuth.instance.currentUser!;
  }

  userSignUp(String email, String password) async {
    isLoading = true;
    notifyListeners();
    final auth = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      print(value.user!.uid);
      user = value.user!;
    }).catchError((error) {
      print(error);
    });

    if (auth.currentUser != null) {
      print(auth.currentUser?.uid);
      final box = GetStorage();
      box.write('userID', auth.currentUser?.uid);
      isLoading = false;
      Get.offAll(() => Home());
    }
    notifyListeners();
  }

  Future<String?> userSignInWithGoogle() async {
    try {
      isLoading = true;
      notifyListeners();
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await _auth.signInWithCredential(credential).then(
        (value) {
          user = value.user!;
          final box = GetStorage();
          print(value.user!.email);
          print(value.user!.displayName);
          print(value.user!.photoURL);
          box.write('userID', FirebaseAuth.instance.currentUser?.uid);
          box.write('Name', value.user!.displayName);
          box.write('email', value.user!.email);
          box.write('photoUrl', value.user!.photoURL);
          writeUserData();
          Get.offAll(() => Home());
        },
      );
    } on FirebaseAuthException catch (e) {
      print(e.message);
      isLoading = false;
      throw e;
    }
    return null;
  }

  writeUserData() {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();
    users.doc(uid).set({
      "displayName": auth.currentUser!.displayName,
      "uid": uid,
      "email": auth.currentUser!.email,
      "photoURL": auth.currentUser!.photoURL,
    });
    isLoading = false;
    notifyListeners();
  }

  getOtherUsers() async {
    otherUsers = [];
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();
    Map<String, dynamic> d;
    await users.get().then(
      (x) {
        x.docs.forEach(
          (element) {
            if (element.id != uid) {
              d = element.data()! as Map<String, dynamic>;
              UserModel user = UserModel.fromJson(d);
              otherUsers.add(user);
              print(d['displayName']);
            }
          },
        );
        notifyListeners();
      },
    );
  }

  signOut() async {
    isLoading = true;
    notifyListeners();
    await _auth.signOut();
    isLoading = false;
    notifyListeners();
    Get.offAll(() => SignUp());
  }

  Future<void> signOutFromGoogle() async {
    isLoading = true;
    notifyListeners();
    await _googleSignIn.signOut();
    await _auth.signOut();
    isLoading = false;
    notifyListeners();
    Get.offAll(() => SignUp());
  }
}
