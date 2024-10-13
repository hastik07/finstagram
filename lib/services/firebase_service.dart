import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

final String user_collection = 'users';

class FirebaseService {
  FirebaseAuth auth = FirebaseAuth.instance; //For User login
  FirebaseStorage storage = FirebaseStorage.instance; //For storing photos
  FirebaseFirestore db = FirebaseFirestore.instance; //For database
  Map? currentUser;

  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        currentUser = await getUserData(uid: userCredential.user!.uid);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<Map> getUserData({required String uid}) async {
    DocumentSnapshot doc = await db.collection(user_collection).doc(uid).get();
    return doc.data() as Map;
  }
}