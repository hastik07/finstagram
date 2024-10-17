import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

final String user_collection = 'users';
final String post_collection = 'posts';

class FirebaseService {
  FirebaseAuth auth = FirebaseAuth.instance; //For User login
  FirebaseStorage storage = FirebaseStorage.instance; //For storing photos
  FirebaseFirestore db = FirebaseFirestore.instance; //For database
  Map? currentUser;

  Future<bool> registerUser({
    required String name,
    required String email,
    required String password,
    required File image,
  }) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String userId = userCredential.user!.uid;
      String fileName = Timestamp.now().millisecondsSinceEpoch.toString() +
          p.extension(image.path);
      UploadTask task = storage.ref('images/$userId/$fileName').putFile(image);
      return task.then(
        (snapshot) async {
          String downloadURL = await snapshot.ref.getDownloadURL();
          await db.collection(user_collection).doc(userId).set(
            {
              'name': name,
              'email': email,
              'image': downloadURL,
            },
          );
          return true;
        },
      );
    } catch (e) {
      print(e);
      return false;
    }
  }

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

  Future<bool> postImage(File image) async {
    try {
      String userId = auth.currentUser!.uid;
      String fileName =
          await Timestamp.now().millisecondsSinceEpoch.toString() +
              p.extension(image.path);
      UploadTask task = storage.ref('images/$userId/$fileName').putFile(image);
      return await task.then(
        (snapshot) async {
          String downloadURL = await snapshot.ref.getDownloadURL();
          await db.collection(post_collection).add({
            'userId': userId,
            'timestamp': Timestamp.now(),
            'image': downloadURL
          });
          return true;
        },
      );
    } catch (e) {
      print(e);
      return false;
    }
  }

  Stream<QuerySnapshot> getPostsUser() {
    String userId = auth.currentUser!.uid;
    return db
        .collection(post_collection)
        .where(
          'userId',
          isEqualTo: userId,
        )
        .snapshots();
  }

  Stream<QuerySnapshot> getLatestPosts() {
    return db
        .collection(post_collection)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> logOut() async {
    await auth.signOut();
  }
}
