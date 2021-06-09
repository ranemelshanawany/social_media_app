import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/Post.dart';
import '../../models/User.dart';
import '../../services/database.dart';
import '../../utils/color.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class PostCard extends StatefulWidget {

  final Post post;
  PostCard(this.post);

  TextEditingController textController = TextEditingController();

  @override
  _PostCardState createState() => _PostCardState(post);
}

class _PostCardState extends State<PostCard> {
  final Post post;


  FirebaseAuth auth = FirebaseAuth.instance;
  User user;
  AppUser appUser;

  List<Post> posts = [];
  List<String> friendsUID = [];

  bool userLoaded = false;
  bool postsFetched = false;

  _PostCardState(this.post);

  @override
  Widget build(BuildContext context) {

    return AspectRatio(
      aspectRatio: 7 /4,
      child: new Card(
        elevation: 1,
        child: Container(
          margin: const EdgeInsets.all(3.0),
          padding: const EdgeInsets.all(2.0),
          child: Column(
            children: <Widget>[
              _buildLocationAndTime(post),
              Divider(color: Colors.grey),
              SizedBox(height: 50, child: Row(children: <Widget>[_buildPostImage(post), _buildPostTitleAndSummary(post)])),
              Divider(color: Colors.grey),
              _buildPostDetails(post),
              Divider(color: Colors.grey),
              Row(
                children: [
                  _buildLikeCount(post),
                  _buildCommentCount(post),
                ],
              ),
            ],
          ),
        ),
      ),
    );

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    appUser = AppUser.WithUID(user.uid);
    getPosts();

    //getUser();
  }



  getUser()
  {
    DatabaseService(uid: user.uid).userCollection.doc(user.uid).snapshots().listen((snapshot) {
      setState(() {
        appUser.UID = snapshot.get("uid");
        appUser.username = snapshot.get("username");
        appUser.email = snapshot.get("email");
        appUser.photoUrl = snapshot.get("photoUrl");
        appUser.displayName = snapshot.get("displayName");
        appUser.bio = snapshot.get("bio");
        userLoaded = true;
        return appUser;
      });
    });
  }

  getPosts() {
    friendsUID = [user.uid];

    CollectionReference textPostsCollection = FirebaseFirestore.instance.collection('textPost');
    CollectionReference imagePostsCollection = FirebaseFirestore.instance.collection('imagePost');
    CollectionReference followCollection = FirebaseFirestore.instance.collection('follow');

    //getting list of friends
    followCollection.where('follower', isEqualTo: user.uid).get().then((value) {
      for(var doc in value.docs)
      {
        friendsUID.add(doc.get('following'));
      }
    });


    textPostsCollection.snapshots().listen((event) {
      for (var docc in event.docs) {
        Map doc = docc.data();
        if (friendsUID.contains(doc['user'])) {
          Post post = ImagePost(
            postID: docc.id,
            text: doc['text'] ?? '',
            date: DateTime.fromMicrosecondsSinceEpoch(doc['date'].microsecondsSinceEpoch)  ?? '',
            user: AppUser.WithUID(doc['user']),
          );
          posts.add(post);
        }
        posts.sort((a,b) => b.date.compareTo(a.date) );
      }
    });
    imagePostsCollection.snapshots().listen((event) {
      for (var docc in event.docs) {
        Map doc = docc.data();
        if (friendsUID.contains(doc['user'])) {
          Post post = ImagePost(
            imageURL: doc['photoAddress'],
            postID: docc.id,
            text: doc['text'] ?? '',
            date: DateTime.fromMicrosecondsSinceEpoch(doc['date'].microsecondsSinceEpoch)  ?? '',
            user: AppUser.WithUID(doc['user']),
          );
          posts.add(post);
        }
        posts.sort((a,b) => b.date.compareTo(a.date) );
      }
    });

    setState(() {
      posts.sort((a,b) => b.date.compareTo(a.date) );
    });
  }


  _buildLocationAndTime(Post post) {

      return Container(
        //width: 400,
        height: 20,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            //_buildLocation(post),
            SizedBox(width: 170),
            _buildPostTimeStamp(post)
          ],
        ),
      );

  }

  _buildPostTitleAndSummary(Post post) {

    //final TextStyle titleTheme = Theme.of(context).textTheme.title;
    //final TextStyle summaryTheme = Theme.of(context).textTheme.body1;

    List<String> titles = ['Looking for a roommate!'];
    List<String> summaries = ['Hi! I am looking for a roommate who is clean, animal lover and vegetarian:)'];

    return Expanded(
      flex: 3,
      child: SizedBox(
        height: 20,
        child: Padding(
          padding: const EdgeInsets.only(left: 2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              //SizedBox(height: 2.0),
              //Text(titles[index], style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18, color: Colors.grey[900])),
              //SizedBox(height: 4.0),
              Expanded(
                child: Text(post.text,
                  style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15, color: Colors.grey[600]),),
              ),
            ],
          ),
        ),
      ),
    );
  }


  _buildPostImage(Post post) {

    return Expanded(flex: 2, child: CircleAvatar(backgroundImage: NetworkImage(post.user.photoUrl == null?
    "https://firebasestorage.googleapis.com/v0/b/cs310-project-cc354.appspot.com/o/unknown.jpg?alt=media&token=71503f0d-a3c9-4837-b2e0-30214a02f0e2"
        : post.user.photoUrl), radius: 20,),
    );
  }

  _buildPostDetails(Post post) {

    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _buildUserImage(post),
          _buildNameAndUsername(post),
          SizedBox(width: 5,),
          SizedBox(width: 5,),
          Container(color: AppColors.primary, height: 48, width: 1.5,),
          _buildLikesAndComments(post),
          //Container(color: AppColors.primary, height: 48, width: 1.5,),
          SizedBox(width:10.0,),
          //_PostTimeStamp(index),
        ],
      ),
    );
  }

  _buildNameAndUsername (Post post) {

    List<String> names = ['Claire Boucher','Mark Geller','Lana Greene','Eric Boucher','Isabella Buffay', 'Matthew Stan'];
    List<String> usernames = ['@cboucher','@markgeller','@lanagreene','@eboucher','@bellabuff', '@mattstan'];


    return Expanded(
      flex: 5,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(post.user.username, style: TextStyle(
                fontSize: 14,
                color: Colors.grey[900]
            ),),
            SizedBox(height: 2.0),
            Text(post.user.displayName, style:  TextStyle(
                fontSize: 12,
                color: Colors.grey[600]
            ),),
          ],
        ),
      ),
    );
  }


  _buildLikesAndComments (Post post) {

    List<String> usernames = ['Claire Boucher','Mark Geller','Lana Greene','Eric Boucher','Isabella Buffay', 'Matthew Stan'];
    List<String> userEmails = ['cboucher@gmail.com','markgeller@gmail.com','lanagreene@gmail.com','eboucher@gmail.com','bellabuff@gmail.com', 'mattstan@gmail.com'];


    return Expanded(
      //width: 50,
      //height: 50,
      flex: 7,
      child:Row(
          children: [
            //SizedBox(width: 10,),
            SizedBox(width: 5,),
            IconButton(icon: Icon(Icons.thumb_up_alt_outlined,size: 27, color: AppColors.primary,), onPressed: () {}),
            SizedBox(width: 5,),
            Container(color: AppColors.primary, height: 48, width: 1.5,),
            SizedBox(width: 5,),
            IconButton(icon: Icon(Icons.mode_comment_outlined,size: 27, color: AppColors.primary,), onPressed: (){}),
            SizedBox(width: 5,),
            Container(color: AppColors.primary, height: 48, width: 1.5,),
            SizedBox(width: 5,),
            IconButton(icon: Icon(Icons.share,size: 27, color: AppColors.primary,), onPressed: (){}),
            SizedBox(width: 5,),

            Container(color: AppColors.primary, height: 48, width: 1.5,),

          ]
      ),

    );
  }

  _buildUserImage (Post post) {

    List<String> usernames = ['Claire Boucher','Mark Geller','Lana Greene','Eric Boucher','Isabella Buffay', 'Matthew Stan'];
    List<String> userEmails = ['cboucher@gmail.com','markgeller@gmail.com','lanagreene@gmail.com','eboucher@gmail.com','bellabuff@gmail.com', 'mattstan@gmail.com'];

    return Container(
      //flex: 2,
      width: 45,
      height: 50,
      child:
      CircleAvatar(backgroundImage: NetworkImage(post.user.photoUrl == null?
      "https://firebasestorage.googleapis.com/v0/b/cs310-project-cc354.appspot.com/o/unknown.jpg?alt=media&token=71503f0d-a3c9-4837-b2e0-30214a02f0e2"
          : post.user.photoUrl), radius: 20,),
    );
  }

  _buildPostTimeStamp (Post post) {

    List<String> postTimes = ["20 April, 2021","19 April, 2021","18 April, 2021","17 April, 2021","16 April, 2021","15 April, 2021","14 April, 2021",];

    return SizedBox(
      //flex:2,
      height: 20,
      width: 100,
      child: Text(DateFormat.yMd().format(post.date), style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.green[900],
      ),),
    );
  }

  _buildLikeCount(Post post) {
    int likes = post.likes;
    String strLikes = likes.toString();
    return SizedBox(

      height: 20,
      width: 100,
      child: Text(strLikes, style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.green[900],
      ),),
    );
  }
  _buildCommentCount(Post post) {
    int likes = post.comments;
    String strComments = likes.toString();
    return SizedBox(

      height: 20,
      width: 100,
      child: Text(strComments, style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.green[900],
      ),),
    );
  }


  _buildLocation (Post post) {

    List<String> postTimes = ["İstanbul","Berlin","İstanbul","London","Barcelona","İstanbul","London",];

    return Container(
      width: 100,
      height: 20,
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      //flex: 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              width: 20.0,
              child: IconButton(icon: Icon(Icons.location_on,size: 20, color: AppColors.primary,), onPressed: (){}, )),
          SizedBox(width:10,),
          Container(
            padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
            child: Text(postTimes[1], style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.green[900],
            ),),
          ),

        ],

      ),
    );
  }

}


