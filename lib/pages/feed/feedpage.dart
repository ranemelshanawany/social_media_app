import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
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
    //getUser();
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

  bool userLoaded = false;

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

    if(!userLoaded)
      getUser();

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

        return Expanded(
          child: Container(
            padding: EdgeInsets.all(8),

            child: ListView.builder(
                itemCount: 6,
                itemBuilder: (BuildContext context, int index) => PostCard(index))),
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
                CircleAvatar(backgroundImage: AssetImage('assets/images/John.jpeg'), radius: 20,),
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
                onPressed: () {Navigator.of(context).pushNamed("/newpost");} )
          ],
        ),
    ),

    );
  }
}

