import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../utils/color.dart';
import '../../models/Post.dart';

class TextPostCard extends StatefulWidget {

  final Post post;
  TextPostCard(this.post);

  @override
  _TextPostCardState createState() => _TextPostCardState(post);
}

class _TextPostCardState extends State<TextPostCard> {
  final Post post;

  int likes = 0;
  int commentsNo = 0;

  _TextPostCardState(this.post);

  @override
  Widget build(BuildContext context) {

    post.likes = likes;
    post.comments = commentsNo;

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUser(),
            SizedBox(height: 10,),
            _buildContent(),
            _buildInteractions()
          ],
        ),
      ),

    );
  }

  _buildUser()
  {
    return Row(
      children: [
        CircleAvatar(backgroundImage: NetworkImage(post.user.photoUrl == null?
        "https://i.pinimg.com/originals/39/1e/e1/391ee12077ba9cabd10e476d8b8c022b.jpg"
            : post.user.photoUrl), radius: 20,),
        SizedBox(width: 10,),
        Text(post.user.username, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
        Spacer(),
        Text(post.date, style: TextStyle(color: Colors.grey),),
      ],
    );
  }

  _buildContent()
  {
    return Text(post.text);
  }

  _buildInteractions()
  {
    return Row(
      children: [
        Text(post.likes.toString(), style: TextStyle(fontSize: 14), ),
        Container(
          width: 18,
          child: IconButton(
              icon: Icon(Icons.thumb_up_alt_outlined,size: 18, color: AppColors.primary,),
              onPressed: () {}),
        ),
        SizedBox(width: 50),
        Text(post.comments.toString(), style: TextStyle(fontSize: 14), ),
        Container(
          width: 18,
          child: IconButton(
              icon: Icon(Icons.mode_comment_outlined,size: 18, color: AppColors.primary,),
              onPressed: (){}),
        )
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLikes();
    getComments();
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

}
