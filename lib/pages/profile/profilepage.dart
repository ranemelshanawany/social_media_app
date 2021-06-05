import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:project_socialmedia/models/User.dart';
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

  int postCount = 0;

  FirebaseAuth auth = FirebaseAuth.instance;
  User user;
  AppUser users;

  List<Post> posts = [
    Post(text: 'First post', date: '18 April 21', likes: 50, comments: 5),
    Post(text: 'Second post', date: '20 April 21', likes: 35, comments: 15),
    Post(text: 'Third post', date: '21 April', likes: 45, comments: 17),
    Post(text: 'Fourth Post', date: '23 April', likes: 49, comments: 27),
    Post(text: 'Room for rent', date: '24 April', likes: 120, comments: 64),
  ];

  void buttonPressed() {
    setState(() {
      postCount += 1;
    });
  }

  Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    user = auth.currentUser;

    return Scaffold(
        backgroundColor: Colors.grey[200],
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primary,
          child: Icon(Icons.add),
          onPressed: buttonPressed,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 0.0),
          child: Column(
            children: [
              _buildUserInformationRow(),
              Divider(
                color: AppColors.primary,
                height: 30,
                thickness: 2.0,
              ),
              _buildStatisticRow(),
              Divider(
                color: AppColors.primary,
                height: 30,
                thickness: 2.0,
              ),
              _buildPostsList(),
            ],
          ),
        ));
  }

  _buildUserInformationRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
          backgroundImage: AssetImage('assets/images/John.jpeg'),
          radius: 40.0,
        ),
        SizedBox(
          width: 8,
        ),
        _buildTextColumnAndEditProfile(),
      ],
    );
  }

  _buildTextColumnAndEditProfile()
  {
    return _buildInformationTextColumn();
  }


  _buildInformationTextColumn() {
    return StreamBuilder(
      stream: DatabaseService(uid: firebaseAuth.currentUser.uid).userCollection.doc(firebaseAuth.currentUser.uid).snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          AppUser user = AppUser.fromJson(snapshot.data.data());}


          return Container(
            width: size.width - 130,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  user.displayName,
                  style: TextStyle(
                    fontFamily: 'BrandonText',
                    fontSize: 28.0,
                    fontWeight: FontWeight.w500,
                    color: AppColors.headingColor,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  user?.uid,
                  style: TextStyle(
                    fontFamily: 'BrandonText',
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor,
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
                      user.email,
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
          );

        }
    );
  }

  _buildStatisticRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        _buildPostNumberColumn(),
        _buildFollowersColumn(),
        _buildFollowingColumn(),
      ],
    );
  }

  _buildPostsList() {
    return Column(
      children: posts
          .map((post) => PostCard(
              post: post,
              delete: () {
                setState(() {
                  posts.remove(post);
                });
              }))
          .toList(),
    );
  }

  _buildPostNumberColumn() {
    return Column(
      children: <Widget>[
        Text(
          'Posts',
          style: TextStyle(
            color: AppColors.textColor,
            fontFamily: 'BrandonText',
            fontSize: 18.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          '$postCount',
          style: TextStyle(
            fontFamily: 'BrandonText',
            fontSize: 24.0,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  _buildFollowersColumn() {
    return Column(
      children: <Widget>[
        Text(
          'Followers',
          style: TextStyle(
            fontFamily: 'BrandonText',
            fontSize: 18.0,
            fontWeight: FontWeight.w400,
            color: AppColors.textColor,
          ),
        ),
        Text(
          '215',
          style: TextStyle(
            fontFamily: 'BrandonText',
            fontSize: 24.0,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  _buildFollowingColumn() {
    return Column(
      children: <Widget>[
        Text(
          'Following',
          style: TextStyle(
            fontFamily: 'BrandonText',
            fontSize: 18.0,
            fontWeight: FontWeight.w400,
            color: AppColors.textColor,
          ),
        ),
        Text(
          '679',
          style: TextStyle(
            fontFamily: 'BrandonText',
            fontSize: 24.0,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
