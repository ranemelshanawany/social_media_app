import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_socialmedia/models/Post.dart';
import 'package:project_socialmedia/models/User.dart'; // add user package
import 'package:firebase_auth/firebase_auth.dart';


FirebaseAuth firebaseAuth = FirebaseAuth.instance;

class DatabaseService{

  final String uid;
  DatabaseService({this.uid});

  CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  CollectionReference textPostsCollection = FirebaseFirestore.instance.collection('textPost');
  CollectionReference imagePostsCollection = FirebaseFirestore.instance.collection('imagePost');
  CollectionReference notificationCollection = FirebaseFirestore.instance.collection('notifications');
  CollectionReference likesCollection = FirebaseFirestore.instance.collection('likes');
  CollectionReference commentsCollection = FirebaseFirestore.instance.collection('comments');

  final CollectionReference postCollection = FirebaseFirestore.instance.collection('posts');

  Future<void> createUserData(String username, String email, String photoUrl, String displayName, String bio) async{
    return await userCollection.doc(uid).set({
      'uid':uid,
      'username': username,
      'email' : email,
      'photoUrl': photoUrl,
      'displayName': displayName,
      'bio': bio
    });

  }

  List<AppUser> _usernameFromSnapshot (QuerySnapshot snapshot) {
    return snapshot.docs.map((doc){
      return AppUser(
        username: doc['name'] ?? '',
      );
    }).toList();

  }

  Future<void> sendLike(String postID, String postUserID) async
  {
    return await likesCollection.doc().set({
      'date': DateTime.now(),
      'liked' : postUserID,
      'liker': uid,
      'postID':postID,
    });
  }

  Future<void> deleteLike(String postID, String postUserID) async
  {
    return await likesCollection.where('liker', isEqualTo: uid).where('postID', isEqualTo: postID).get().then((value) {
      for (var doc in value.docs)
      {
        likesCollection.doc(doc.id).delete();
      }
    });
  }

  Future<void> createComment({String content, DateTime date, String userCommented, String postID, String commentingUsername}) async{
    return await commentsCollection.doc().set({
      'date': date,
      'content': content,
      'userCommented' : userCommented,
      'userCommenting': commentingUsername,
      'postID':postID,
    });
  }

  Future<void> createTextPost(String text, String date) async{
    return await textPostsCollection.doc().set({
      'text': text,
      'date' : date,
      'user': uid,
    });
  }

  Future<void> createImagePost(String text, String date, photoURL) async{
    return await imagePostsCollection.doc().set({
      'text': text,
      'date' : date,
      'photoAddress':photoURL,
      'user': uid,
    });
  }

  List<AppUser> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc){
      return AppUser(
        username: doc['username'] ?? '',
        UID: doc['uid'] ?? '',
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

  List<Post> _postListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc){
      return Post(
        text: doc['text'] ?? '',
        date: doc['date'] ?? '',
        user: AppUser.WithUID(doc['user']),
      );
    }).toList();
  }

  Stream<List<Post>> get posts {
    return userCollection.snapshots().map(_postListFromSnapshot);
  }
}


