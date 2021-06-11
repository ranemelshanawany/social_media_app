import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:project_socialmedia/models/Comments.dart';
import 'package:project_socialmedia/models/User.dart';
import 'package:project_socialmedia/pages/otherUserProfile.dart';
import 'package:project_socialmedia/pages/reportDialog.dart';
import '../../utils/color.dart';
import '../../models/Post.dart';
import 'package:project_socialmedia/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../deleteDialog.dart';

class PostPage extends StatefulWidget {

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  final ImagePost imagePost;

  PostPage(this.imagePost, this.analytics,this.observer);

  @override
  _PostPageState createState() => _PostPageState(imagePost);
}

class _PostPageState extends State<PostPage> {
  ImagePost post;

  _PostPageState(this.post);

  User user;
  AppUser appUser;
  int likes = 0;
  int commentsNo = 0;
  List<Comment> comments = [];

  bool liked = false;
  bool likeFetched = false;

  TextEditingController commentsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    user = FirebaseAuth.instance.currentUser;

    appUser = AppUser.WithUID(user.uid);
    post.likes = likes;
    post.comments = commentsNo;
    post.commentsList = comments;
    user = FirebaseAuth.instance.currentUser;
    if (!likeFetched)
      getLikedStatus(post.postID);

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(children: [
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
          post.commentsList != null? _buildCommentsList() : Container(),
          _buildCommenting(),
        ],),
      ),
    );
  }

  _buildCommenting()
  {
    return Container(
      width: MediaQuery.of(context).size.width*0.95,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    contentPadding: EdgeInsets.all(0),
                    title: TextField(
                      controller: commentsController,
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey[700],
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: AppColors.primary,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.primary,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintText: "Write your comment...",
                        hintStyle: TextStyle(
                          fontSize: 15.0,
                          color: Colors.grey[700],
                        ),
                      ),
                      maxLines: null,
                    ),
                    trailing: IconButton(
                      onPressed: (){
                        sendComment();
                        commentsController.clear();
                      },
                      icon: Icon(Icons.send, color: AppColors.primary, size: 30,),
                      padding: EdgeInsets.all(0),
                    ),
                  ),])
          ],
        )
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
      actionsIconTheme:  IconThemeData(color: Colors.white),
      actions: [
        (post.user.UID == user.uid) ?
        PopupMenuButton<int>(
          onSelected: (item) {
          if (item == 1)
            showReportDialog(context, "post", reportPost);
          if (item == 2)
            showDeleteDialog(context, 'image', user.uid, post.postID);
          },
          itemBuilder: (context) => [
            PopupMenuItem<int>(
              value: 1,
              child: Text('Report'),
            ),
            PopupMenuItem<int>(
              value: 2,
              child: Text('Delete'),
            )
          ],) :
        PopupMenuButton<int>(
          onSelected: (item) {
            if (item == 1)
              showReportDialog(context, "post", reportPost);
          },
          itemBuilder: (context) => [
            PopupMenuItem<int>(
              value: 1,
              child: Text('Report'),
            ),
          ],)
      ],
    );
  }

  _buildCommentsList()
  {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ListView.builder(
        itemCount: post.commentsList.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: EdgeInsets.all(0),
        itemBuilder: (context, index) {
          return Row(
            children: [
              Text(post.commentsList[index].userCommenting, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
              SizedBox(width: 10,),
              Text(post.commentsList[index].content, style: TextStyle(fontSize: 16),),
            ],
          );
        },
      ),
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
            sendLike();
          });
        }),
      ],
    );
  }

  _buildUser()
  {
    return Container(
      padding: EdgeInsets.all(10),
      child: InkWell(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileBuilder(post.user)),
          );
        },
        child: Row(
          children: [
            CircleAvatar(backgroundImage: post.user.photoUrl == null? NetworkImage(post.user.photoUrl): AssetImage('assets/images/John.jpeg'),),
            SizedBox(width: 10,),
            Text(post.user.username, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
            Spacer(),
            Text(DateFormat.yMd().format(post.date), style: TextStyle(color: Colors.grey),),
          ],
        ),
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

  sendComment() async
  {
    if (commentsController.text.isNotEmpty) {
      await DatabaseService(uid: FirebaseAuth.instance.currentUser.uid).createComment(
        postID: post.postID,
          content: commentsController.text,
          userCommented: post.user.username,
          commentingUsername: appUser.username,
          uid: appUser.UID,
          date: DateTime.now());
      //DateFormat.yMd().format(DateTime.now())
    }
    getComments();
  }

  sendLike() async {
    if (liked)
    {
      await DatabaseService(uid: user.uid).sendLike(post.postID, post.user.UID, post.user.username);
    }
    else {
      await DatabaseService(uid: user.uid).deleteLike(post.postID, post.user.UID);
    }
    getLikedStatus(post.postID);
  }


  getLikes()
  {
    CollectionReference likesCollection = FirebaseFirestore.instance.collection('likes');
    likesCollection.where("postID", isEqualTo: post.postID).snapshots().listen((value) {
        likes = 0;
        for(var doc in value.docs)
        {
          likes++;
        }
    });
  }

  getComments() async
  {
    CollectionReference commentsCollection = FirebaseFirestore.instance.collection('comments');
    commentsCollection.where("postID", isEqualTo: post.postID).get().then((value) {
        comments = [];
        commentsNo = 0;
        for(var doc in value.docs)
        {
          Timestamp time = doc.get('date');
          DateTime date = DateTime.fromMicrosecondsSinceEpoch(time.microsecondsSinceEpoch);
          Comment comment = Comment(postID: post.postID, content: doc.get('content'), userCommentedOn: doc.get('userCommented'),
              userCommenting: doc.get('userCommenting'), date: date);
          comments.add(comment);
          commentsNo++;
        }
        setState(() {
          comments.sort((a,b) => a.date.compareTo(b.date));
        });
    });
  }

  getLikedStatus(String postID)
  {
    CollectionReference likesCollection = FirebaseFirestore.instance.collection('likes');
    likesCollection.where('liker', isEqualTo: user.uid).where('postID', isEqualTo: postID).get().then((event) {
      if (event.size > 0) {
          setState(() {
            liked = true;
            likeFetched = true;
          });
      }
      else {
        setState(() {
          liked = false;
                likeFetched = true;
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setLogEvent();
    _setCurrentScreen();
    getComments();
    getLikes();
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

  reportPost() async {
    await DatabaseService(uid: user.uid).sendPostReport(post.postID);
  }

}
