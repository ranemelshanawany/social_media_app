import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:project_socialmedia/models/User.dart';
import 'package:project_socialmedia/pages/exploreAndSearch/imagePostInSearch.dart';
import 'package:project_socialmedia/pages/exploreAndSearch/textPosts.dart';
import 'package:project_socialmedia/pages/profile/connectionslist.dart';
import '../../utils/color.dart';
import 'postCard.dart';
import '../../models/Post.dart';
import 'package:project_socialmedia/models/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_socialmedia/services/database.dart';


class Profile extends StatefulWidget {

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  final profileID;

  @override
  _ProfileState createState() => _ProfileState();

  Profile({this.profileID, this.analytics, this.observer});
}

class _ProfileState extends State<Profile> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setLogEvent();
    _setCurrentScreen();
    FirebaseAuth auth = FirebaseAuth.instance;
    user = auth.currentUser;
  }

  User user;
  AppUser appUser = AppUser();
  bool userLoaded = false;

  int followersNo = 0;
  int followingNo = 0;
  bool fetchedFollowers = false;
  bool fetchedFollowing = false;

  bool postsLoading = false;
  bool postsFetched = false;
  List<Post> posts;
  List<AppUser> followers = [];
  List<AppUser> following = [];

  Size size;

  @override
  Widget build(BuildContext context) {

    if(!userLoaded)
      getUser();
    if(!postsFetched) {
      getPosts();
    }
    if(!fetchedFollowers)
      getFollowersCount();
    if(!fetchedFollowing)
      getFollowingCount();

    size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.grey[100],
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageRow(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(appUser.bio == null? "" : appUser.bio, style: TextStyle(fontSize: 16),),
                  ),
                  _buildStats()
                ],
              ),
            ),
          ),
          _buildPosts()
        ],
      ),
    );
  }

  _buildPosts(){
    if(postsLoading)
    {
      return Center(child: CircularProgressIndicator());
    }
    else if (posts.isEmpty)
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(child: Text("No posts found", style: TextStyle(fontSize: 20),)),
      );
    else {
      return Container(
        height: MediaQuery.of(context).size.height-350,
        child: ListView.builder(
            itemCount: posts.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              if (posts[index].runtimeType == ImagePost)
              { return ImagePostCard(posts[index]);}
              else {
                return TextPostCard(posts[index]);
              }
            }),
      );
    }
  }

  _buildImageRow()
  {
    return Row(
      children: [
        CircleAvatar(backgroundImage: appUser.photoUrl == null? NetworkImage("https://firebasestorage.googleapis.com/v0/b/cs310-project-cc354.appspot.com/o/unknown.jpg?alt=media&token=71503f0d-a3c9-4837-b2e0-30214a02f0e2") :NetworkImage(appUser.photoUrl),
          radius: 40,),
        SizedBox(width: 15,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                appUser.displayName == null? "" : appUser.displayName,
                style: TextStyle(
                  fontFamily: 'BrandonText',
                  fontSize: 25.0,
                  fontWeight: FontWeight.w500,
                  color: AppColors.headingColor,
                ),
              ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.email,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    appUser.email == null? "" : appUser.email,
                    style: TextStyle(
                      fontFamily: 'BrandonText',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColor,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),

      ],
    );
  }

  getUser() async
  {
    await DatabaseService(uid: user.uid).userCollection.doc(user.uid).get().then((snapshot) {
      setState(() {
        appUser.UID = snapshot.get("uid");
        appUser.username = snapshot.get("username");
        appUser.email = snapshot.get("email");
        appUser.photoUrl = snapshot.get("photoUrl") != null? snapshot.get("photoUrl") : "https://firebasestorage.googleapis.com/v0/b/cs310-project-cc354.appspot.com/o/unknown.jpg?alt=media&token=71503f0d-a3c9-4837-b2e0-30214a02f0e2";
        appUser.displayName = snapshot.get("displayName");
        appUser.bio = snapshot.get("bio");
        userLoaded = true;
      });
    });
  }

  _buildStats()
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildPostNumberColumn(),
        Container(
          width: 1,
          height: 50,
          color: Colors.grey,
        ),
        _buildFollowersColumn(),
        Container(
          width: 1,
          height: 50,
          color: Colors.grey,
        ),
        _buildFollowingColumn(),

      ],
    );
  }

  _buildPostNumberColumn() {
    return Column(
      children: <Widget>[
        Text(
          posts.length.toString(),
          style: TextStyle(
            fontFamily: 'BrandonText',
            fontSize: 20.0,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
        Text(
          'Posts',
          style: TextStyle(
            color: AppColors.textColor,
            fontFamily: 'BrandonText',
            fontSize: 18.0,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  _buildFollowersColumn() {
    return InkWell(
      onTap: () async
      {
        await getFollowers();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ConnectionsList(followers)),
        );
      },
      child: Column(
        children: <Widget>[
          Text(
            followersNo.toString(),
            style: TextStyle(
              fontFamily: 'BrandonText',
              fontSize: 20.0,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
          Text(
            'Followers',
            style: TextStyle(
              fontFamily: 'BrandonText',
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
              color: AppColors.textColor,
            ),
          ),
        ],
      ),
    );
  }

  _buildFollowingColumn() {
    return InkWell(
        onTap: () async
        {
          await getFollowing();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ConnectionsList(following)),
          );
        },
      child: Column(
        children: <Widget>[
          Text(
            followingNo.toString(),
            style: TextStyle(
              fontFamily: 'BrandonText',
              fontSize: 20.0,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
          Text(
            'Following',
            style: TextStyle(
              fontFamily: 'BrandonText',
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
              color: AppColors.textColor,
            ),
          ),
        ],
      ),
    );
  }

  getFollowersCount()
  {
    fetchedFollowers = true;
    CollectionReference followPostsCollection = FirebaseFirestore.instance.collection('follow');
    followPostsCollection.where("following", isEqualTo: user.uid).snapshots().listen((event) {
      followersNo = event.size;
    });
  }

  getFollowingCount()
  {
    fetchedFollowing = true;
    CollectionReference followPostsCollection = FirebaseFirestore.instance.collection('follow');
    followPostsCollection.where("follower", isEqualTo: user.uid).snapshots().listen((event) {
      followingNo = event.size;
    });
  }

  getPosts() {
    setState(() {
      postsLoading = true;
    });
    posts = [];
    CollectionReference textPostsCollection =
    FirebaseFirestore.instance.collection('textPost');
    CollectionReference imagePostsCollection =
    FirebaseFirestore.instance.collection('imagePost');
    textPostsCollection.snapshots().listen((event) {
      for (var docc in event.docs) {
        Map doc = docc.data();
          if (doc['user'].contains(user.uid)) {
            Post post = Post(
              postID: docc.id,
              text: doc['text'] ?? '',
              date: DateTime.fromMicrosecondsSinceEpoch(doc['date'].microsecondsSinceEpoch)  ?? '',
              user: AppUser.WithUID(doc['user']),
            );
            posts.add(post);
          }
      }
    });
    imagePostsCollection.get().then((event) {
      for (var docc in event.docs) {
        Map doc = docc.data();
        if (doc['user'].contains(user.uid)) {
          Post post = ImagePost(
              postID: docc.id,
              text: doc['text'] ?? '',
              date: DateTime.fromMicrosecondsSinceEpoch(doc['date'].microsecondsSinceEpoch)  ?? '',
              user: AppUser.WithUID(doc['user']),
              imageURL: doc['photoAddress'] ??
                  "https://www.indianhorizons.net/assets/lib/images/default.png");

          posts.add(post);
        }
      }
    });
    postsFetched = true;
    setState(() {
      posts.sort((a,b) => b.date.compareTo(a.date) );
      postsLoading = false;
    });
  }

  Future<void> _setCurrentScreen() async{
    await widget.analytics.setCurrentScreen(
        screenName: 'Profile_Page',
        screenClassOverride: 'Profile_Page'

    );
  }

  Future<void> _setLogEvent() async{
    await widget.analytics.logEvent(
        name: 'Profile_Page',
        parameters: <String,dynamic> {
          'string': 'Profile_Page'
        }
    );
  }

  getFollowers() async {
    followers = [];
    List<String> uids = [];

    CollectionReference followPostsCollection = FirebaseFirestore.instance.collection('follow');
    await followPostsCollection.where("following", isEqualTo: user.uid).get().then((event) {
      for (var doc in event.docs)
      {
        uids.add(doc.get("follower"));
      }
    });


    CollectionReference userCollection =
    FirebaseFirestore.instance.collection('users');
    await userCollection
        .get()
        .then((event) {
      for (var doc in event.docs) {
        if (uids.contains(doc["uid"])) {
          AppUser appUser = AppUser(
            UID: doc["uid"] ??"",
            username: doc["username"]??"",
            email: doc["email"]??"",
            photoUrl: doc["photoUrl"]??"https://firebasestorage.googleapis.com/v0/b/cs310-project-cc354.appspot.com/o/unknown.jpg?alt=media&token=71503f0d-a3c9-4837-b2e0-30214a02f0e2",
            displayName: doc["displayName"]??"",
            bio: doc["bio"]??"",
            private: doc["private"]?? false,
          );
          followers.add(appUser);
        }
      }
    });
  }

  getFollowing() async {
    following = [];
    List<String> uids = [];

    CollectionReference followPostsCollection = FirebaseFirestore.instance.collection('follow');
    followPostsCollection.where("follower", isEqualTo: user.uid).get().then((event) {
      for (var doc in event.docs)
      {
        uids.add(doc.get("following"));
      }
    });


    CollectionReference userCollection =
    FirebaseFirestore.instance.collection('users');
    await userCollection
        .get()
        .then((event) {
      for (var doc in event.docs) {
        if (uids.contains(doc["uid"])) {
          AppUser appUser = AppUser(
            UID: doc["uid"] ??"",
            username: doc["username"]??"",
            email: doc["email"]??"",
            photoUrl: doc["photoUrl"]??"https://firebasestorage.googleapis.com/v0/b/cs310-project-cc354.appspot.com/o/unknown.jpg?alt=media&token=71503f0d-a3c9-4837-b2e0-30214a02f0e2",
            displayName: doc["displayName"]??"",
            bio: doc["bio"]??"",
            private: doc["private"]?? false,
          );
          following.add(appUser);
        }
      }
    });
  }
}
