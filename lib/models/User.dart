import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_socialmedia/services/database.dart';


class AppUser {
  String UID ="";
  String username = "";
  String email = "";
  String photoUrl = "https://firebasestorage.googleapis.com/v0/b/cs310-project-cc354.appspot.com/o/unknown.jpg?alt=media&token=71503f0d-a3c9-4837-b2e0-30214a02f0e2";
  String displayName = "";
  String bio = "";
  bool private = false;


  AppUser ({
    this.UID,
    this.username,
    this.email,
    this.photoUrl,
    this.displayName,
    this.bio,
    this.private
    }
   );

  AppUser.WithUID(String uid)
  {
    DatabaseService(uid: uid).userCollection.doc(uid).get().then((snapshot) {
      UID = uid;
      username = snapshot.get("username") ?? "";
      email = snapshot.get("email") ?? "";
      photoUrl = snapshot.get("photoUrl") ?? "https://firebasestorage.googleapis.com/v0/b/cs310-project-cc354.appspot.com/o/unknown.jpg?alt=media&token=71503f0d-a3c9-4837-b2e0-30214a02f0e2";
      displayName = snapshot.get("displayName")?? "";
      bio = snapshot.get("bio")?? "";
      private = snapshot.get("private")?? false;
    });
  }

   AppUser.fromJson(Map<String, dynamic> json) {
    UID = json['uid'];
     username = json['username'];
     email = json['email'];
     photoUrl = json['photoUrl'];
     bio = json['bio'];
     displayName = json['displayname'];
     private = json['private'];

   }

   Map<String, dynamic> toJson() {
     final Map<String, dynamic> data = new Map<String, dynamic>();
     data['uid'] = this.UID;
     data['username'] = this.username;
     data['email'] = this.email;
     data['photoUrl'] = this.photoUrl;
     data['bio'] = this.bio;
     data['displayName'] = this.displayName;
     data['private'] = this.private;

     return data;
   }

 }