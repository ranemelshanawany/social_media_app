import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_socialmedia/models/Comments.dart';
import 'package:project_socialmedia/models/User.dart';
import 'package:project_socialmedia/services/database.dart';
import '../../utils/color.dart';
import '../../models/Post.dart';
import 'package:intl/intl.dart';

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
  List<Comment> comments = [];

  TextEditingController commentsController = TextEditingController();

  bool liked = false;
  bool likeFetched = false;

  AppUser appUser;

  _TextPostCardState(this.post);

  @override
  Widget build(BuildContext context) {

    post.likes = likes;
    post.comments = commentsNo;
    post.commentsList = comments;
    appUser = AppUser.WithUID(FirebaseAuth.instance.currentUser.uid);

    if (!likeFetched)
      getLikedStatus(post.postID);

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
        Text(DateFormat.yMd().format(post.date), style: TextStyle(color: Colors.grey),),
      ],
    );
  }

  _buildContent()
  {
    return Text(post.text, style: TextStyle(fontSize: 16),);
  }

  _buildInteractions()
  {
    return Row(
      children: [
        Text(post.likes.toString(), style: TextStyle(fontSize: 14), ),
        Container(
          width: 18,
          child: IconButton(
              icon: Icon(liked? Icons.favorite : Icons.favorite_border,size: 22, color: Colors.pink[200],),
              onPressed: () {
                liked = !liked;
                sendLike();
              }),
        ),
        SizedBox(width: 50),
        Text(post.comments.toString(), style: TextStyle(fontSize: 14), ),
        Container(
          width: 18,
          child: IconButton(
              icon: Icon(Icons.mode_comment_outlined,size: 18, color: AppColors.primary,),
              onPressed: (){
                showComments();
              }),
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
        likes = 0;
        for(var doc in value.docs)
        {
          likes++;
        }
      });
    });
  }

  getComments() async
  {
    CollectionReference commentsCollection = FirebaseFirestore.instance.collection('comments');
    commentsCollection.where("postID", isEqualTo: post.postID).snapshots().listen((value) {
      setState(() {
        comments = [];
        commentsNo = 0;
        for(var docc in value.docs)
        {
          Map doc = docc.data();
          Timestamp time = doc['date'];
          DateTime date = DateTime.fromMicrosecondsSinceEpoch(time.microsecondsSinceEpoch);
          Comment comment = Comment(postID: post.postID, content: doc['content'], userCommentedOn: doc['userCommented'],
              userCommenting: doc['userCommenting'], date: date);
          comments.add(comment);
          commentsNo++;
        }
        comments.sort((a,b) => a.date.compareTo(b.date));
      });
    });
  }

  sendLike() async {
    if (liked)
    {
      await DatabaseService(uid: FirebaseAuth.instance.currentUser.uid).sendLike(post.postID, post.user.UID);
    }
    else {
      await DatabaseService(uid: FirebaseAuth.instance.currentUser.uid).deleteLike(post.postID, post.user.UID);
    }
  }

  getLikedStatus(String postID)
  {
    CollectionReference likesCollection = FirebaseFirestore.instance.collection('likes');
    likesCollection.where('liker', isEqualTo: FirebaseAuth.instance.currentUser.uid).where('postID', isEqualTo: postID).snapshots().listen((event) {
      if (event.size > 0) {
        setState(() {
          liked = true;
          likeFetched = true;
        });
      }
      else {
        liked = false;
        likeFetched = false;
      }
    });
  }

  showComments() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20,),
                _buildCaption(),
                _buildComments(),
                _buildCommenting()
              ],
            ),
          );
        });
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

  _buildComments()
  {
    if(comments.isEmpty)
      return Container();
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: post.commentsList.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: EdgeInsets.all(0),
        itemBuilder: (context, index) {
          return Row(
            children: [
              Text(post.commentsList[index].userCommentedOn, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
              SizedBox(width: 10,),
              Text(post.commentsList[index].content, style: TextStyle(fontSize: 16),),
            ],
          );
        },
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

  sendComment() async
  {
    if (commentsController.text.isNotEmpty) {
      await DatabaseService(uid: FirebaseAuth.instance.currentUser.uid).createComment(
          postID: post.postID,
          content: commentsController.text,
          userCommented: post.user.username,
          commentingUsername: appUser.username,
          date: DateTime.now());
      //DateFormat.yMd().format(DateTime.now())
    }
  }

}
