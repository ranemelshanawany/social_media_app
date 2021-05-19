import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import '../../utils/color.dart';
import 'post_card.dart';

class Feed extends StatefulWidget {

  Feed({this.analytics,this.observer});

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  TextEditingController textController = TextEditingController();

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {

  String _message = '';

  void setMessage(String msg){
    setState(() {
      _message = msg;
    });

  }

  Future<void> _setLogEvent() async{
    await widget.analytics.logEvent(
        name: 'new_post_page',
        parameters: <String,dynamic> {
          'string': 'new_post'
        }
    );
    setMessage('New post page log event succeeded');
  }

  Future<void> _firebase_event_origin() async{
    await widget.analytics.logEvent(
        name: 'new_post_page',
        parameters: <String,dynamic> {
          'string': 'new_post'
        }
    );
    setMessage('New post page log event succeeded');
  }

  List<bool> _selection = [true, false];
  final _formKey = GlobalKey<FormState>();

  FirebaseAuth auth = FirebaseAuth.instance;
  User user;

  get onPressed => null;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    user = auth.currentUser;

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
                      Text(user.displayName, style: TextStyle(color: Colors.grey[700] ,fontWeight: FontWeight.bold, fontSize: 18),),
                      SizedBox(height: 4),
                      Text('@JohnF', style: TextStyle(color: Colors.grey[500] ,fontWeight: FontWeight.bold, fontSize: 14),),
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

