import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_socialmedia/models/Notifications.dart';
import 'package:project_socialmedia/models/Post.dart';
import 'package:project_socialmedia/models/User.dart'; // add user package
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_socialmedia/utils/shared_prefs.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;

class DatabaseService{

  final String uid;
  DatabaseService({this.uid});

  CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  CollectionReference followCollection = FirebaseFirestore.instance.collection('follow');
  CollectionReference followRequestCollection = FirebaseFirestore.instance.collection('followRequest');
  CollectionReference textPostsCollection = FirebaseFirestore.instance.collection('textPost');
  CollectionReference imagePostsCollection = FirebaseFirestore.instance.collection('imagePost');
  CollectionReference sharedPostsCollection = FirebaseFirestore.instance.collection('sharedPost');
  CollectionReference notificationCollection = FirebaseFirestore.instance.collection('notifications');
  CollectionReference likesCollection = FirebaseFirestore.instance.collection('likes');
  CollectionReference commentsCollection = FirebaseFirestore.instance.collection('comments');
  CollectionReference userReportsCollection = FirebaseFirestore.instance.collection('userReports');
  CollectionReference postReportsCollection = FirebaseFirestore.instance.collection('postReports');
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

  Future<void> deleteUser(AppUser user) async{
    //first delete user
    MySharedPreferences.setLoginBooleanValue(false);
    await userCollection.doc(uid).delete();
    await FirebaseAuth.instance.currentUser.delete();

    deletePostsUser();
    deleteCommentsUser(user.username);
    deleteLikesUser();
    deleteFollowUser();
    deleteNotificationsUser();
  }

  //for when user is deleted
  Future<void> deletePostsUser() async{
    //delete posts
    textPostsCollection.where("user", isEqualTo: uid).get().then((event) {
      for (var doc in event.docs)
        textPostsCollection.doc(doc.id).delete();
    });
    imagePostsCollection.where("user", isEqualTo: uid).get().then((event) {
      for (var doc in event.docs)
        imagePostsCollection.doc(doc.id).delete();
    });
    sharedPostsCollection..get().then((event) {
      for (var doc in event.docs) {
        if (doc.get("userSharing") ==  uid || doc.get('userShared') == uid) {
          sharedPostsCollection.doc(doc.id).delete();
        }
      }
    });
  }
  //for when user is deleted
  Future<void> deleteFollowUser() async{
    //delete followers, following, follow requests
    followCollection.get().then((event) {
      for (var doc in event.docs) {
        if (doc.get('follower') == uid || doc.get('following') == uid) {
          followCollection.doc(doc.id).delete();
        }
      }
    });
    followRequestCollection.get().then((event) {
      for (var doc in event.docs) {
        if (doc.get('personSending') == uid || doc.get('personReceiving') == uid) {
          followRequestCollection.doc(doc.id).delete();
        }
      }
    });
  }
  //for when user is deletedpp
  Future<void> deleteNotificationsUser() async{
    notificationCollection.get().then((event) {
      for (var doc in event.docs) {
        if (doc.get('owner') == uid || doc.get('sender') == uid) {
          notificationCollection.doc(doc.id).delete();
        }
      }
    });
  }
  //for when user is deleted
  Future<void> deleteCommentsUser(String uname) async{
    commentsCollection.get().then((event) {
      for (var doc in event.docs) {
        if (doc.get('userCommented') == uname || doc.get('userCommenting') == uname) {
          commentsCollection.doc(doc.id).delete();
        }
      }
    });
  }
  //for when user is deleted
  Future<void> deleteLikesUser() async{
    likesCollection.get().then((event) {
      for (var doc in event.docs) {
        if (doc.get('liker') == uid || doc.get('liked') == uid) {
          likesCollection.doc(doc.id).delete();
        }
      }
    });
  }


  List<AppUser> _usernameFromSnapshot (QuerySnapshot snapshot) {
    return snapshot.docs.map((doc){
      return AppUser(
        username: doc['name'] ?? '',
      );
    }).toList();

  }

  Future<void> sendUserReport(String user) async
  {
    return await userReportsCollection.doc().set({
      'reportedUser':user,
      'reporter': uid,
    });
  }

  Future<void> sendPostReport(String postID) async
  {
    return await postReportsCollection.doc().set({
      'reportedPost':postID,
      'reporter': uid,
    });
  }

  Future<void> sendLike(String postID, String postUserID, String username) async
  {
    createNotification(postUserID, uid, "like", "", postID, DateTime.now());
    return await likesCollection.doc().set({
      'date': DateTime.now(),
      'liked' : postUserID,
      'liker': uid,
      'postID':postID,
    });
  }

  Future<void> deleteLike(String postID, String postUserID) async
  {
    deleteLikeNotification(postID);
    return await likesCollection.where('liker', isEqualTo: uid).where('postID', isEqualTo: postID).get().then((value) {
      for (var doc in value.docs)
      {
        likesCollection.doc(doc.id).delete();
      }
    });
  }

  Future<void> deleteLikeNotification(String postID) async
  {
    return await notificationCollection.where('sender', isEqualTo: uid).where('postID', isEqualTo: postID).where('notificationType', isEqualTo: "like").get().then((value) {
      for (var doc in value.docs)
      {
        notificationCollection.doc(doc.id).delete();
      }
    });
  }

    Future<void> createComment({String content, DateTime date, String userCommented, String postID, String commentingUsername, String uid}) async{
    createNotification(userCommented,commentingUsername,"comment",content,postID,date);
    return await commentsCollection.doc().set({
      'date': date,
      'content': content,
      'userCommented' : userCommented,
      'userCommenting': commentingUsername,
      'postID':postID,
    });
  }

  Future<void> createNotification(String ownerID, String senderID, String type, String commentData, String postID, DateTime date) async{
    return await notificationCollection.doc().set({
      'owner': ownerID,
      'sender': senderID,
      'notificationType': type,
      'commentCont': commentData,
      'postID': postID,
      'date': date,
    });
  }

  Future<void> deleteCommentNotification(String postID) async
  {
    return await notificationCollection.where('sender', isEqualTo: uid).where('postID', isEqualTo: postID).where('notificationType', isEqualTo: "comment").get().then((value) {
      for (var doc in value.docs)
      {
        notificationCollection.doc(doc.id).delete();
      }
    });
  }

  Future<void> deleteFollowNotification(String userID) async
  {
    return await notificationCollection.where('sender', isEqualTo: uid).where('owner', isEqualTo: userID).where('notificationType', isEqualTo: "follow").get().then((value) {
      for (var doc in value.docs)
      {
        notificationCollection.doc(doc.id).delete();
      }
    });
  }

  Future<void> deleteRequestNotification(String userID) async
  {
    return await notificationCollection.where('sender', isEqualTo: uid).where('owner', isEqualTo: userID).where('notificationType', isEqualTo: "request").get().then((value) {
      for (var doc in value.docs)
      {
        notificationCollection.doc(doc.id).delete();
      }
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

  Future<void> deleteImagePost(String postID) async{
    imagePostsCollection.doc(postID).delete();
    commentsCollection.where("postID", isEqualTo: postID).get().then((value) {
      for(var doc in value.docs)
        commentsCollection.doc(doc.id).delete();
    });
    likesCollection.where("postID", isEqualTo: postID).get().then((value) {
      for(var doc in value.docs)
        likesCollection.doc(doc.id).delete();
    });
    notificationCollection.where("postID", isEqualTo: postID).get().then((value) {
      for(var doc in value.docs)
        notificationCollection.doc(doc.id).delete();
    });
  }

  Future<void> deleteTextPost(String postID) async{

    textPostsCollection.doc(postID).delete();
    commentsCollection.where("postID", isEqualTo: postID).get().then((value) {
      for(var doc in value.docs)
        commentsCollection.doc(doc.id).delete();
    });
    likesCollection.where("postID", isEqualTo: postID).get().then((value) {
      for(var doc in value.docs)
        likesCollection.doc(doc.id).delete();
    });
    notificationCollection.where("postID", isEqualTo: postID).get().then((value) {
      for(var doc in value.docs)
        notificationCollection.doc(doc.id).delete();
    });
  }
  
  

  Future<void> follow(String user, String username) async{

    createNotification(user, uid, "follow", "", "", DateTime.now());
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
    deleteFollowNotification(user);
    return await followCollection.where('follower', isEqualTo: uid).where('following', isEqualTo: user).get().then((value) {
      for (var doc in value.docs)
      {
        followCollection.doc(doc.id).delete();
      }
    });
  }

  Future<void> sendFollowRequest(String user, String username) async{
    createNotification(user, uid, "request", "", "", DateTime.now());
    return await followRequestCollection.doc().set({
      'personSending': uid,
      'personReceiving': user,
    });
  }

  Future<void> deleteFollowRequest(String user) async{
    deleteRequestNotification(user);
    return await followRequestCollection.where('personSending', isEqualTo: uid).where('personReceiving', isEqualTo: user).get().then((value) {
      for (var doc in value.docs)
      {
        followRequestCollection.doc(doc.id).delete();
      }
    });
  }

  Stream<AppUser> get currentUser {
    print("in get current user");
    return userCollection.doc(uid).snapshots().map(_userFromSnapshot);
  }

  AppUser _userFromSnapshot(DocumentSnapshot snapshot)
  {
    print("Snapshot here: " + snapshot.data());
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
        username: doc.get('username') ?? '',
        UID: doc.get('uid') ?? '',
        email: doc.get('email') ?? '',
        photoUrl: doc.get('photoUrl') ?? '',
        displayName: doc.get('displayName') ?? '',
        bio: doc.get('bio') ?? '',
        private: doc.get('private') ?? false,
      );
    }).toList();
  }

  Stream<List<AppUser>> get users {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }


  List<AppUser> _commentListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc){
      return AppUser(
        username: doc.get('username') ?? '',
        UID: doc.get('uid') ?? '',
        email: doc.get('email') ?? '',
        photoUrl: doc.get('photoUrl') ?? '',
        displayName: doc.get('displayName') ?? '',
        bio: doc.get('bio') ?? '',
        private: doc.get('private') ?? false,
      );
    }).toList();
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

  List<Notifications> _notificationListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc){
      return Notifications(
          date: doc['date'] ?? '',
      );
    }).toList();
  }

  Stream<List<Notifications>> get notifications {
    return userCollection.snapshots().map(_notificationListFromSnapshot);
  }

  Future<void> deleteNotificationsFromPage() async{
    notificationCollection.get().then((event) {
      for (var doc in event.docs) {
        if (doc.get('owner') == uid) {
          notificationCollection.doc(doc.id).delete();
        }
      }
    });
  }

}


