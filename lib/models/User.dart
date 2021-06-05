import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  String username = "";
  String email = "";
  String photoUrl = "";
  String displayName = "";
  String bio = "";

  AppUser ({
    this.username,
    this.email,
    this.photoUrl,
    this.displayName,
    this.bio,
    }
   );

  AppUser.toAppUser(DocumentSnapshot doc) {
    username= doc['name'] ?? '';
    email= doc['email'] ?? '';
    photoUrl= doc['photoUrl'] ?? '';
    displayName= doc['displayName'] ?? '';
    bio= doc['bio'] ?? '';
  }
 }