import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:project_socialmedia/models/Post.dart';
import 'package:project_socialmedia/models/User.dart';
import 'package:project_socialmedia/services/database.dart';
import 'package:project_socialmedia/utils/shared_prefs.dart';
import 'package:provider/provider.dart';
import '../../utils/color.dart';
import 'post_card.dart';
import '../../services/location.dart';

class Feed extends StatefulWidget {

  Feed({this.analytics,this.observer});

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  TextEditingController textController = TextEditingController();

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setLogEventFeed();
    _setCurrentScreen();
    user = FirebaseAuth.instance.currentUser;
    appUser = AppUser.WithUID(user.uid);
    //posts = [];
    getPosts();
    //getUser();
    setState(() {});
  }



  Future<void> _setLogEventFeed() async{
    await widget.analytics.logEvent(
        name: 'Feed_Page',
        parameters: <String,dynamic> {
          'string': 'feed_page'
        }
    );
  }

  Future<void> _setCurrentScreen() async{
    await widget.analytics.setCurrentScreen(
        screenName: 'Feed_Page',
        screenClassOverride: 'Feed_Page'

    );
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  User user;
  AppUser appUser;

  List<ImagePost> posts = [];
  List<String> friendsUID = [];

  bool userLoaded = false;
  bool postsFetched = false;

  getUser()
  {
    DatabaseService(uid: user.uid).userCollection.doc(user.uid).snapshots().listen((snapshot) {
      setState(() {
        appUser.UID = snapshot.get("uid");
        appUser.username = snapshot.get("username");
        appUser.email = snapshot.get("email");
        appUser.photoUrl = snapshot.get("photoUrl");
        appUser.displayName = snapshot.get("displayName");
        appUser.bio = snapshot.get("bio");
        userLoaded = true;
        return appUser;
      });
    });
  }

  get onPressed => null;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print("First length: ");
    print(posts.length);
    if(!userLoaded)
      getUser();
    if(!postsFetched)
      getPosts();
    print("Second length: ");
    print(posts.length);


    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNewPostCard(size),
          ],
        ),
        Divider(color: AppColors.primary, thickness: 1.0,),
        _buildContentDisplay(size),
      ],
    );
  }


  _buildContentDisplay(Size size) {
    int len = posts.length;
    print("İŞTE BURADASIN");
    print(len);
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(8),
        child: SizedBox(
          height: 10,
          child: new ListView.builder(
              itemCount: 8,
              itemBuilder: (BuildContext context, int index) => PostCard(posts[index])),
        ),
      ),
    );
  }


  _buildNewPostCard(Size size) {

    return Card(
      elevation: 1,
      margin: EdgeInsets.all(12.0),
      shadowColor: Colors.grey[50],
      child: Container(
        width: 380,
        padding: EdgeInsets.all(12.0),
        child:
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(backgroundImage: NetworkImage(appUser.photoUrl), radius: 20,),
                //Image.network(user.photoURL, width: size.width-10, fit: BoxFit.fill,),
                SizedBox(width: 10,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(appUser.displayName == null? "": appUser.displayName , style: TextStyle(color: Colors.grey[700] ,fontWeight: FontWeight.bold, fontSize: 18),),
                      SizedBox(height: 4),
                      Text("@"+appUser.username == null? "" : appUser.username , style: TextStyle(color: Colors.grey[500] ,fontWeight: FontWeight.bold, fontSize: 14),),
                    ],
                  ),
                ),

              ],
            ),
            RaisedButton(
                color: AppColors.primary,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(' New Post',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 5,),
                    Icon(Icons.add,color: Colors.white,),
                  ],
                ),
                onPressed: () {Navigator.of(context).pushNamed("/newpost"); getPosts();} )
          ],
        ),
      ),

    );
  }

  getPosts() {

    friendsUID = [user.uid];

    CollectionReference textPostsCollection = FirebaseFirestore.instance.collection('textPost');
    CollectionReference imagePostsCollection = FirebaseFirestore.instance.collection('imagePost');
    CollectionReference followCollection = FirebaseFirestore.instance.collection('follow');

    //getting list of friends
    followCollection.where('follower', isEqualTo: user.uid).get().then((value) {
      for(var doc in value.docs)
      {
        friendsUID.add(doc.get('following'));
      }
    });

    textPostsCollection.snapshots().listen((event) {
      posts = [];
      for (var docc in event.docs) {
        Map doc = docc.data();
        if (friendsUID.contains(doc['user'])) {
          Post post1 = ImagePost(
            reposter: AppUser.WithUID(doc['reposter']),
            imageURL: null,
            postID: docc.id,
            text: doc['text'] ?? '',
            date: DateTime.fromMicrosecondsSinceEpoch(doc['date'].microsecondsSinceEpoch)  ?? '',
            user: AppUser.WithUID(doc['user']),
            //likes: doc.likes;
          );
          posts.add(post1);
        }
        posts.sort((a,b) => b.date.compareTo(a.date) );
      }
    });
    imagePostsCollection.snapshots().listen((event) {
      for (var docc in event.docs) {
        Map doc = docc.data();
        if (friendsUID.contains(doc['user'])) {
          Post post1 = ImagePost(
            reposter: AppUser.WithUID(doc['reposter']),
            imageURL: doc['photoAddress'],
            postID: docc.id,
            text: doc['text'] ?? '',
            date: DateTime.fromMicrosecondsSinceEpoch(doc['date'].microsecondsSinceEpoch)  ?? '',
            user: AppUser.WithUID(doc['user']),
            //likes: docc.likes;
          );
          posts.add(post1);
        }
        posts.sort((a,b) => b.date.compareTo(a.date) );
      }
    });

    setState(() {
      posts.sort((a,b) => b.date.compareTo(a.date) );
      //initState();
    });
  }
}

