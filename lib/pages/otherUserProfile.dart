import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_socialmedia/models/Post.dart';
import 'package:project_socialmedia/models/User.dart';
import 'package:project_socialmedia/services/database.dart';
import 'package:project_socialmedia/utils/color.dart';
import 'package:project_socialmedia/utils/dialog_widget.dart';
import 'reportDialog.dart';

import 'exploreAndSearch/imagePostInSearch.dart';
import 'exploreAndSearch/textPosts.dart';

class ProfileBuilder extends StatefulWidget {

  AppUser user;

  ProfileBuilder(this.user);

  @override
  _ProfileBuilderState createState() => _ProfileBuilderState(user);
}

class _ProfileBuilderState extends State<ProfileBuilder> {
  AppUser user;
  AppUser currentUser;

  bool following = false;
  bool postsLoading = false;
  bool postsFetched = false;
  int followersNo = 0;
  int followingNo = 0;

  bool fetchedStatus = false;
  bool fetchedFollowers = false;
  bool fetchedFollowing = false;

  bool canSeePosts = true;
  bool requestExists = false;

  List<Post> posts;

  _ProfileBuilderState(this.user);

  @override
  Widget build(BuildContext context) {

    if(!postsFetched) {
      getPosts();
    }
    if(!fetchedStatus) {
      getFollowStatus();
      getRequestStatus();
    }
    if(!fetchedFollowers)
      getFollowersCount();
    if(!fetchedFollowing)
      getFollowingCount();

    canSeePosts = user.private && !following && (currentUser.UID != user.UID);

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar:  _buildAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.grey[100],
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageRow(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(user.bio, style: TextStyle(fontSize: 16),),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                    child: Row(
                      children: [
                        Expanded(child: _buildFollowButton()),
                      ],
                    ),
                  ),
                  _buildStats()
                ],
              ),
            ),
          ),
          _buildPosts()
        ],
      ),
    );
  }

  _buildPosts(){
    if (canSeePosts)
      return Expanded(child: Center(child: Text("User Private ", style: TextStyle(fontSize: 20)),));
    else if(postsLoading)
    {
      return Center(child: CircularProgressIndicator());
    }
    else if (posts.isEmpty)
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(child: Text("No posts found", style: TextStyle(fontSize: 20),)),
      );
    else {
      return Container(
        height: MediaQuery.of(context).size.height-350,
        child: ListView.builder(
            itemCount: posts.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              if (posts[index].runtimeType == ImagePost)
              { return ImagePostCard(posts[index]);}
              else {
                return TextPostCard(posts[index]);
              }
            }),
      );
    }
  }

  getPosts() {
    setState(() {
      postsLoading = true;
    });
    posts = [];
    CollectionReference textPostsCollection =
    FirebaseFirestore.instance.collection('textPost');
    CollectionReference imagePostsCollection =
    FirebaseFirestore.instance.collection('imagePost');
    textPostsCollection.get().then((event) {
      for (var docc in event.docs) {
        Map doc = docc.data();
        if (doc['user'].contains(user.UID)) {
          Post post = Post(
            postID: docc.id,
            text: doc['text'] ?? '',
            date: DateTime.fromMicrosecondsSinceEpoch(doc['date'].microsecondsSinceEpoch)  ?? '',
            user: AppUser.WithUID(doc['user']),
          );
            posts.add(post);
        }
      }
    });
    imagePostsCollection.get().then((event) {
      for (var docc in event.docs) {
        Map doc = docc.data();
        if (doc['user'].contains(user.UID)) {
          Post post = ImagePost(
              postID: docc.id,
              text: doc['text'] ?? '',
              date: DateTime.fromMicrosecondsSinceEpoch(doc['date'].microsecondsSinceEpoch)  ?? '',
              user: AppUser.WithUID(doc['user']),
              imageURL: doc['photoAddress'] ??
                  "https://www.indianhorizons.net/assets/lib/images/default.png");

            posts.add(post);
        }
      }
    });
    postsFetched = true;
    setState(() {
      posts.sort((a,b) => b.date.compareTo(a.date) );
      postsLoading = false;
    });
  }

  _buildFollowButton()
  {
    if (currentUser.UID == user.UID)
      return Container();
    else if (requestExists)
    {
      return Container(
        height: 50,
        child: OutlinedButton(onPressed: () {
          sendFollow();
        },
            style: OutlinedButton.styleFrom(
                backgroundColor: Colors.grey[100],
                side: BorderSide(color: Colors.grey[700])
            ),
            child: Text("Request Sent", style: TextStyle(fontSize: 20, color:  Colors.grey[700]),)),
      );
    }
    else {
      return Container(
        height: 50,
        child: OutlinedButton(onPressed: () {
            sendFollow();
        },
            style: OutlinedButton.styleFrom(
              backgroundColor: following? Colors.grey[100] : AppColors.primary,
              side: BorderSide(color: AppColors.primary)
            ),
            child: Text(following? "Following": "Follow", style: TextStyle(fontSize: 20, color: following? AppColors.primary : Colors.white),)),
      );
    }
  }

  _buildStats()
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildPostNumberColumn(),
        Container(
          width: 1,
          height: 50,
          color: Colors.grey,
        ),
        _buildFollowersColumn(),
        Container(
          width: 1,
          height: 50,
          color: Colors.grey,
        ),
        _buildFollowingColumn(),

      ],
    );
  }

  _buildPostNumberColumn() {
    return Column(
      children: <Widget>[
        Text(
          posts.length.toString(),
          style: TextStyle(
            fontFamily: 'BrandonText',
            fontSize: 20.0,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
        Text(
          'Posts',
          style: TextStyle(
            color: AppColors.textColor,
            fontFamily: 'BrandonText',
            fontSize: 18.0,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  _buildFollowersColumn() {
    return Column(
      children: <Widget>[
        Text(
          followersNo.toString(),
          style: TextStyle(
            fontFamily: 'BrandonText',
            fontSize: 20.0,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
        Text(
          'Followers',
          style: TextStyle(
            fontFamily: 'BrandonText',
            fontSize: 18.0,
            fontWeight: FontWeight.w400,
            color: AppColors.textColor,
          ),
        ),
      ],
    );
  }

  _buildFollowingColumn() {
    return Column(
      children: <Widget>[
        Text(
          followingNo.toString(),
          style: TextStyle(
            fontFamily: 'BrandonText',
            fontSize: 20.0,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
        Text(
          'Following',
          style: TextStyle(
            fontFamily: 'BrandonText',
            fontSize: 18.0,
            fontWeight: FontWeight.w400,
            color: AppColors.textColor,
          ),
        ),
      ],
    );
  }

  _buildImageRow()
  {
    return Row(
      children: [
        CircleAvatar(backgroundImage: user.photoUrl == ""? AssetImage('assets/images/John.jpeg') :NetworkImage(user.photoUrl),
        radius: 40,),
        SizedBox(width: 15,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                user.displayName,
                style: TextStyle(
                  fontFamily: 'BrandonText',
                  fontSize: 25.0,
                  fontWeight: FontWeight.w500,
                  color: AppColors.headingColor,
                ),
              ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.email,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    user.email,
                    style: TextStyle(
                      fontFamily: 'BrandonText',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColor,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),

      ],
    );
  }

  getFollowersCount()
  {
    fetchedFollowers = true;
    CollectionReference followPostsCollection = FirebaseFirestore.instance.collection('follow');
    followPostsCollection.where("following", isEqualTo: user.UID).snapshots().listen((event) {
        followersNo = event.size;
    });
  }

  getFollowingCount()
  {
    fetchedFollowing = true;
    CollectionReference followPostsCollection = FirebaseFirestore.instance.collection('follow');
    followPostsCollection.where("follower", isEqualTo: user.UID).snapshots().listen((event) {
      followingNo = event.size;
    });
  }

  sendFollow() async
  {
    //doesnt make sense but it's reversed for reasons and ch.
    if(following) {
      await DatabaseService(uid: currentUser.UID).unfollow(user.UID);
    }

    if(!following){
      if(user.private) {
        if (requestExists)
          await DatabaseService(uid: currentUser.UID).deleteFollowRequest(user.UID);
        else
          await DatabaseService(uid: currentUser.UID).sendFollowRequest(user.UID);
      } else
        await DatabaseService(uid: currentUser.UID).follow(user.UID);
    }

    setState(() {
      fetchedFollowers = false;
    });

  }

  _buildAppBar()
  {
    return AppBar(
      centerTitle: true,
      title: Text("@"+user.username, style: TextStyle(color: Colors.white),),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.white,),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actionsIconTheme:  IconThemeData(color: Colors.white),
      actions: [
        PopupMenuButton<int>(
          onSelected: (item) { showReportDialog(context, "user", reportUser); },
          itemBuilder: (context) => [
            PopupMenuItem<int>(
              value: 1,
              child: Text('Report'),
            ),
          ],)
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUser = AppUser.WithUID(FirebaseAuth.instance.currentUser.uid);
  }

  getFollowStatus()
  {
    CollectionReference followCollection = FirebaseFirestore.instance.collection('follow');
    followCollection.where("follower", isEqualTo: FirebaseAuth.instance.currentUser.uid).where("following", isEqualTo: user.UID).snapshots().listen((value) {
      if(value.size > 0)
        {
          setState(() {
            following = true;
          });
        } else
          {
            setState(() {
              following = false;
            });
          }
    });
    fetchedStatus = true;
  }

  getRequestStatus()
  {
    CollectionReference followRequestCollection = FirebaseFirestore.instance.collection('followRequest');
    followRequestCollection.where("personSending", isEqualTo: FirebaseAuth.instance.currentUser.uid).where("personReceiving", isEqualTo: user.UID).snapshots().listen((value) {
      if(value.size > 0)
      {
          requestExists = true;
      } else if (value.size == 0)
      {
          setState(() {
            requestExists = false;
          });
      }
    });
  }

  reportUser() async {
    await DatabaseService(uid: currentUser.UID).sendUserReport(user.UID);
  }

}
