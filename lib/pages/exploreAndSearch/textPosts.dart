import 'package:flutter/material.dart';
import 'package:project_socialmedia/utils/color.dart';
import '../../models/Post.dart';

class TextPostCard extends StatefulWidget {

  final Post post;
  TextPostCard(this.post);

  @override
  _TextPostCardState createState() => _TextPostCardState(post);
}

class _TextPostCardState extends State<TextPostCard> {
  final Post post;

  _TextPostCardState(this.post);

  @override
  Widget build(BuildContext context) {
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
        CircleAvatar(backgroundImage: NetworkImage(post.user.photoUrl), radius: 20,),
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

}
