import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_socialmedia/models/Post.dart';
import 'package:project_socialmedia/models/User.dart'; // add user package
import 'package:firebase_auth/firebase_auth.dart';


FirebaseAuth firebaseAuth = FirebaseAuth.instance;

class DatabaseService{

  final String uid;
  DatabaseService({this.uid});

  CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  CollectionReference followCollection = FirebaseFirestore.instance.collection('follow');
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
      'bio': bio,
      'private': false
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

  Future<void> createTextPost(String text, DateTime date) async{
    return await textPostsCollection.doc().set({
      'text': text,
      'date' : date,
      'user': uid,
    });
  }

  Future<void> createImagePost(String text, DateTime date, photoURL) async{
    return await imagePostsCollection.doc().set({
      'text': text,
      'date' : date,
      'photoAddress':photoURL,
      'user': uid,
    });
  }

  Future<void> follow(String user) async{
    return await followCollection.doc().set({
      'follower': uid,
      'following': user,
    });
  }
  //follower is the person who clicked the follow button
  //following is the person who is being followed

  Future<void> unfollow(String user) async
  {
    print("unfollow");
    return await followCollection.where('follower', isEqualTo: uid).where('following', isEqualTo: user).get().then((value) {
      for (var doc in value.docs)
      {
        followCollection.doc(doc.id).delete();
      }
    });
  }



  AppUser _userFromSnapshot(DocumentSnapshot snapshot)
  {
    return AppUser(
        username: snapshot.get('username')?? '',
        UID: snapshot.get('uid')?? '',
        email: snapshot.get('email')?? '',
        photoUrl: snapshot.get('photoUrl')?? '',
        displayName: snapshot.get('displayName')?? '',
        bio: snapshot.get('bio')?? '',
        private: snapshot.get('private')?? false,
      );
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
        private: doc['private'] ?? false,
      );
    }).toList();
  }

  Stream<List<AppUser>> get users {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }

  Stream<AppUser> get currentUser {
    return userCollection.doc(uid).snapshots().map(_userFromSnapshot);
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


