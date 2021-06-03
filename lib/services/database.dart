import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_socialmedia/models/User.dart'; // add user package
import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;

class DatabaseService{

  final String uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference notificationCollection = FirebaseFirestore.instance.collection('notifications');

  Future<void> createUserData(String username, String email, String photoUrl, String displayName, String bio) async{
    return await userCollection.doc(uid).set({
      'username': username,
      'email' : email,
      'photoUrl': photoUrl,
      'displayName': displayName,
      'bio': bio
    });

  }

  List<AppUser> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc){
      return AppUser(
        username: doc['name'] ?? '',
        email: doc['email'] ?? '',
        photoUrl: doc['photoUrl'] ?? '',
        displayName: doc['displayName'] ?? '',
        bio: doc['bio'] ?? '',
      );
    }).toList();
  }

  Stream<List<AppUser>> get users {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }
}