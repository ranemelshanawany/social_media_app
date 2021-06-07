import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_socialmedia/models/Post.dart';
import 'package:project_socialmedia/models/User.dart';
import 'package:project_socialmedia/services/database.dart';
import 'package:project_socialmedia/utils/color.dart';

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

  bool samePerson = false;
  bool following = false;
  bool postsLoading = false;
  bool postsFetched = false;
  int followersNo = 0;
  int followingNo = 0;

  bool fetchedStatus = false;
  bool fetchedFollowers = false;

  List<Post> posts;

  _ProfileBuilderState(this.user);

  @override
  Widget build(BuildContext context) {

    if(!postsFetched) {
      getPosts();
      getFollowingCount();
    }
    if(!fetchedStatus)
      getFollowStatus();
    if(!fetchedFollowers)
      getFollowersCount();

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
    if(postsLoading)
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
    textPostsCollection.snapshots().listen((event) {
      for (var docc in event.docs) {
        Map doc = docc.data();
        if (doc['user'].contains(user.UID)) {
          Post post = Post(
            postID: docc.id,
            text: doc['text'] ?? '',
            date: DateTime.fromMicrosecondsSinceEpoch(doc['date'].microsecondsSinceEpoch)  ?? '',
            user: AppUser.WithUID(doc['user']),
          );
          setState(() {
            postsFetched = true;
            posts.add(post);
            postsLoading = false;
            posts.sort((a,b) => b.date.compareTo(a.date) );
          });
        }
      }
    });
    imagePostsCollection.snapshots().listen((event) {
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
          setState(() {
            postsFetched = true;
            posts.add(post);
            postsLoading = false;
            posts.sort((a,b) => b.date.compareTo(a.date) );
          });
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
    if (samePerson)
      return Container();
    if (following) {
      return Container(
        height: 50,
        child: OutlinedButton(onPressed: () {
          setState(()  {
            following = !following;
          });
            sendFollow();
        },
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.grey[100],
              side: BorderSide(color: AppColors.primary)
            ),
            child: Text("Following", style: TextStyle(fontSize: 20, color: AppColors.primary),)),
      );
    }
    if(!following)
    {
      return Container(
        height: 50,
        child: OutlinedButton(onPressed: () {
          setState(()  {
            following = !following;
          });
          sendFollow();
        },
            style: OutlinedButton.styleFrom(
                backgroundColor: AppColors.primary
            ),
            child: Text("Follow", style: TextStyle(fontSize: 20, color: Colors.white))),
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
        CircleAvatar(backgroundImage: NetworkImage(user.photoUrl == null?
        "https://i.pinimg.com/originals/39/1e/e1/391ee12077ba9cabd10e476d8b8c022b.jpg"
            : user.photoUrl),
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
    CollectionReference followPostsCollection = FirebaseFirestore.instance.collection('follow');
    followPostsCollection.where("following", isEqualTo: user.UID).get().then((event) {
      setState(() {
        followersNo = event.size;
        fetchedFollowers = false;
      });
    });
  }

  getFollowingCount()
  {
    CollectionReference followPostsCollection = FirebaseFirestore.instance.collection('follow');
    followPostsCollection.where("follower", isEqualTo: user.UID).get().then((event) {
      setState(() {
        followersNo = event.size;
      });
    });
  }

  sendFollow() async
  {
    if(!following) {
      await DatabaseService(uid: currentUser.UID).unfollow(user.UID);
    }

    if(following){
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
    followCollection.where("follower", isEqualTo: currentUser.UID).where("following", isEqualTo: user.UID).get().then((value) {
      for (var doc in value.docs)
        {
          setState(() {
            following = true;
          });
          break;
        }
    });
    print(following);
    fetchedStatus = true;
  }

}
