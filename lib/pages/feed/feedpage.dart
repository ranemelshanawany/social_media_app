import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../utils/color.dart';
import 'post_card.dart';

class Feed extends StatefulWidget {
  TextEditingController textController = TextEditingController();

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {

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

