import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import '../../utils/color.dart';
import '../../models/Post.dart';

class PostPage extends StatefulWidget {

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  final ImagePost post;

  PostPage(this.post, this.analytics,this.observer);

  @override
  _PostPageState createState() => _PostPageState(post);
}

class _PostPageState extends State<PostPage> {
  ImagePost post;

  _PostPageState(this.post);

  int likes = 0;
  int commentsNo = 0;

  bool liked = false;

  @override
  Widget build(BuildContext context) {

    post.likes = likes;
    post.comments = commentsNo;

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBack(),
          Card(
            elevation: 0,
            child: Column(
              children: [
                _buildUser(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Image.network(post.imageURL, width: size.width-10, fit: BoxFit.fill,),
                ),
                _buildLikesAndComments(),
                _buildCaption(),
              ],
            ),
          ),
          _buildCommentsContainer(),
          //_buildCommentsList()

        ],
      ),
    );
  }

  _buildCommentsContainer()
  {
    return Expanded(
      flex: 1,
      child: Container(
          child: Padding(
            padding: const EdgeInsets.only(top:12.0, left: 12, right: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                post.commentsList != null? _buildCommentsList() : Container()
              ],
            ),
          )
      ),
    );
  }

  _buildBack()
  {
    return AppBar(
      backgroundColor: AppColors.primary,
      title: Text("Explore", style: TextStyle(color: Colors.white),),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
    );
  }

  _buildCommentsList()
  {
    return ListView.builder(
      itemCount: post.commentsList.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      padding: EdgeInsets.all(0),
      itemBuilder: (context, index) {
        return Row(
          children: [
            Text(post.commentsList[index].user.username, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
            SizedBox(width: 10,),
            Text(post.commentsList[index].content, style: TextStyle(fontSize: 16),),
          ],
        );
      },
    );
  }

  _buildLikesAndComments()
  {
    int likes = post.likes;
    int comments = post.comments;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12,5,12,0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$likes likes     $comments comments", style: TextStyle(fontSize: 16, color: Colors.grey[700]),),
          _buildInteractions(),
        ],
      ),
    );
  }

  _buildInteractions()
  {
    return Row(
      children: [
        SizedBox(width: 10,),
        IconButton(icon: Icon(!liked? Icons.favorite_border : Icons.favorite,size: 30, color: Colors.pink[300],), onPressed: () {
          //TODO add a like on db
          //TODO notify likee
          setState(() {
            liked = !liked;
          });
        }),
      ],
    );
  }

  _buildUser()
  {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          CircleAvatar(backgroundImage: NetworkImage(post.user.photoUrl == null?
          "https://i.pinimg.com/originals/39/1e/e1/391ee12077ba9cabd10e476d8b8c022b.jpg"
              : post.user.photoUrl),),
          SizedBox(width: 10,),
          Text(post.user.username, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
          Spacer(),
          Text(post.date, style: TextStyle(color: Colors.grey),),
        ],
      ),
    );
  }

  _buildCaption()
  {
    if(post.text == "")
      return Container();
    return Padding(
      padding: const EdgeInsets.fromLTRB(12,0,12,12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(post.user.username, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
          SizedBox(width: 10,),
          Expanded(child: Text(post.text, style: TextStyle(fontSize: 18),)),
        ],
      ),
    );
  }

  getLikes()
  {
    CollectionReference likesCollection = FirebaseFirestore.instance.collection('likes');
    likesCollection.where("postID", isEqualTo: post.postID).snapshots().listen((value) {
      setState(() {
        for(var doc in value.docs)
        {
          likes++;
        }
      });
    });
  }

  getComments()
  {
    CollectionReference commentsCollection = FirebaseFirestore.instance.collection('comments');
    commentsCollection.where("postID", isEqualTo: post.postID).snapshots().listen((value) {
      setState(() {
        for(var doc in value.docs)
        {
          commentsNo++;
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setLogEvent();
    _setCurrentScreen();
    getLikes();
    getComments();
  }

  Future<void> _setLogEvent() async{
    await widget.analytics.logEvent(
        name: 'Image_post_Page',
        parameters: <String,dynamic> {
          'string': 'Image_post_Page'
        }
    );
  }

  Future<void> _setCurrentScreen() async{
    await widget.analytics.setCurrentScreen(
        screenName: 'Image_post_Page',
        screenClassOverride: 'Image_post_Page'

    );
  }

}
