import 'package:flutter/material.dart';
import 'package:project_socialmedia/utils/color.dart';
import '../models/Post.dart';

class PostPage extends StatefulWidget {

  final ImagePost post;

  PostPage(this.post);

  @override
  _PostPageState createState() => _PostPageState(post);
}

class _PostPageState extends State<PostPage> {
  ImagePost post;

  _PostPageState(this.post);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUser(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Image.network(post.imageURL, width: size.width-10, fit: BoxFit.fill,),
            ),
            _buildlikesandcomments(),
            _buildInteractions(),
            _buildCaption()

          ],
        ),
      ),
    );
  }

  _buildlikesandcomments()
  {
    int likes = post.likes;
    int comments = post.comments;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0,12,12,0),
      child: Row(
        children: [
          Text("$likes likes, $comments comments", style: TextStyle(fontSize: 18),),
        ],
      ),
    );
  }

  _buildInteractions()
  {
    return Row(
      children: [
        SizedBox(width: 10,),
        IconButton(icon: Icon(Icons.thumb_up,size: 30, color: AppColors.primary,), onPressed: () {}),
        SizedBox(width: 0,),
        IconButton(icon: Icon(Icons.mode_comment,size: 30, color: AppColors.primary,), onPressed: (){})
      ],
    );
  }

  _buildUser()
  {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          CircleAvatar(backgroundImage: AssetImage('assets/images/John.jpeg'),),
          SizedBox(width: 10,),
          Text("username", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
          Spacer(),
          Text(post.date, style: TextStyle(color: Colors.grey),),
        ],
      ),
    );
  }

  _buildCaption()
  {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(11.0),
          child: Text("username", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
        ),
        Text(post.text, style: TextStyle(fontSize: 18),),
      ],
    );
  }

}
