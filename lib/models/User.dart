import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_socialmedia/services/database.dart';


class AppUser {
  String UID ="";
  String username = "";
  String email = "";
  String photoUrl = "https://i.pinimg.com/originals/39/1e/e1/391ee12077ba9cabd10e476d8b8c022b.jpg";
  String displayName = "";
  String bio = "";


  AppUser ({
    this.UID,
    this.username,
    this.email,
    this.photoUrl,
    this.displayName,
    this.bio,
    }
   );

  AppUser.WithUID(String uid)
  {
    DatabaseService(uid: uid).userCollection.doc(uid).get().then((snapshot) {
      UID = uid;
      username = snapshot.get("username");
      email = snapshot.get("email");
      photoUrl = snapshot.get("photoUrl");
      displayName = snapshot.get("displayName");
      bio = snapshot.get("bio");
    });
  }

   AppUser.fromJson(Map<String, dynamic> json) {
    UID = json['uid'];
     username = json['username'];
     email = json['email'];
     photoUrl = json['photoUrl'];
     bio = json['bio'];
     displayName = json['displayname'];
   }

   Map<String, dynamic> toJson() {
     final Map<String, dynamic> data = new Map<String, dynamic>();
     data['uid'] = this.UID;
     data['username'] = this.username;
     data['email'] = this.email;
     data['photoUrl'] = this.photoUrl;
     data['bio'] = this.bio;
     data['displayName'] = this.displayName;

     return data;
   }

 }