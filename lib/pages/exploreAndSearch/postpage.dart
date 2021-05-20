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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setLogEvent();
    _setCurrentScreen();
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

  _PostPageState(this.post);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBack(),
          _buildUser(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Image.network(post.imageURL, width: size.width-10, fit: BoxFit.fill,),
          ),
          _buildLikesAndComments(),
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
          decoration: BoxDecoration(
            color: Color(0xFFF1F8F4),
              border: Border(top: BorderSide(color: Color(0xFF2FE57D))
              ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top:12.0, left: 12, right: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildCaption(),
                _buildCommentsList()
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
      title: Text("Explore"),
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
      padding: const EdgeInsets.fromLTRB(0,5,12,0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildInteractions(),
          Text("$likes likes, $comments comments", style: TextStyle(fontSize: 16, color: AppColors.primary),),
        ],
      ),
    );
  }

  _buildInteractions()
  {
    return Row(
      children: [
        SizedBox(width: 10,),
        IconButton(icon: Icon(Icons.thumb_up_alt_outlined,size: 30, color: AppColors.primary,), onPressed: () {}),
        SizedBox(width: 0,),
        IconButton(icon: Icon(Icons.mode_comment_outlined,size: 30, color: AppColors.primary,), onPressed: (){})
      ],
    );
  }

  _buildUser()
  {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          CircleAvatar(backgroundImage: NetworkImage(post.user.photoUrl),),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(post.user.username, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
        SizedBox(width: 10,),
        Text(post.text, style: TextStyle(fontSize: 16),),
      ],
    );
  }

}
