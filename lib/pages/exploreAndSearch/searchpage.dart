import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:project_socialmedia/models/Post.dart';
import 'package:project_socialmedia/models/User.dart';
import 'package:project_socialmedia/pages/exploreAndSearch/imagePostInSearch.dart';
import 'package:project_socialmedia/pages/exploreAndSearch/textPosts.dart';
import 'package:project_socialmedia/pages/exploreAndSearch/usersInSearch.dart';
import 'package:project_socialmedia/utils/color.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({this.analytics, this.observer});

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Future<void> _setLogEvent() async {
    await widget.analytics.logEvent(
        name: 'Search_Page', parameters: <String, dynamic>{'string': 'search'});
  }

  Future<void> _setCurrentScreen() async {
    await widget.analytics.setCurrentScreen(
        screenName: 'Search_Page', screenClassOverride: 'Search_Page');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setLogEvent();
    _setCurrentScreen();
  }

  final searchController = TextEditingController(text: "");
  bool submitted = false;

  List<Post> posts = [];
  List<AppUser> users = [];
  bool postsLoading = false;
  bool usersLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _buildSearchBar(),
      ),
    );
  }

  _buildSearchBar() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                padding: EdgeInsets.only(left: 10),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  height: 50,
                  margin: EdgeInsets.fromLTRB(0, 8, 8, 8),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey[300],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: Colors.grey[700],
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Flexible(
                        child: TextField(
                          onChanged: (value) {
                            if (submitted) {
                              setState(() {
                                submitted = false;
                              });
                            }
                          },
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: "Search",
                            filled: false,
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),
                          autofocus: true,
                          onSubmitted: (value) {
                            setState(() {
                              submitted = true;
                            });
                            searchPosts();
                            searchUsers();
                            print("Posts length: " + posts.length.toString());
                            print("Users length: " + users.length.toString());
                            print(value);
                          },
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          searchController.clear();
                        },
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildResults()
        ],
      ),
    );
  }

  _buildResults() {
    if (!submitted) {
      return Container();
    } else {
      return Column(
        children: [
          _buildToggleButton(MediaQuery.of(context).size),
          SizedBox(
            height: 17,
          ),
          _buildResultsContent()
        ],
      );
    }
  }

  List<bool> _selection = [true, false];

  _buildToggleButton(Size size) {
    return ToggleButtons(
      children: [
        _buildToggleWidget(size, "Posts"),
        _buildToggleWidget(size, "People")
      ],
      isSelected: _selection,
      onPressed: (int index) {
        setState(() {
          _selection[index] = true;
          if (index == 0) _selection[1] = false;
          if (index == 1) _selection[0] = false;
        });
      },
      color: AppColors.primary,
      selectedColor: Colors.white,
      fillColor: AppColors.primary,
      selectedBorderColor: AppColors.primary,
      borderColor: AppColors.primary,
    );
  }

  _buildToggleWidget(Size size, String text) {
    return Container(
        width: size.width / 2 - 5, child: Center(child: Text(text)));
  }

  _buildResultsContent() {
    if (_selection[0]) {
      if(postsLoading)
      {
        return Center(child: CircularProgressIndicator());
      }
      else if (posts.isEmpty)
        return Text("No posts found");
      else {
        return Container(
          height: MediaQuery.of(context).size.height-170,
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
    else {
      if(usersLoading)
      {
        return Center(child: CircularProgressIndicator());
      }
      else if (users.isEmpty)
        return Text("No people found");
      else {
        return Container(
          height: MediaQuery.of(context).size.height-170,
          child: ListView.builder(
              itemCount: users.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return UsersSearchCard(users[index]);
              }),
        );
      }
    }
  }

  searchPosts() {
    setState(() {
      postsLoading = true;
    });
    posts = [];
    CollectionReference textPostsCollection =
        FirebaseFirestore.instance.collection('textPost');
    CollectionReference imagePostsCollection =
        FirebaseFirestore.instance.collection('imagePost');
    textPostsCollection.snapshots().listen((event) {
      for (var doc in event.docs) {
        if (doc['text'].contains(searchController.text)) {
          Post post = Post(
            postID: doc.id,
            text: doc['text'] ?? '',
            date: DateTime.fromMicrosecondsSinceEpoch(doc['date'].microsecondsSinceEpoch) ?? '',
            user: AppUser.WithUID(doc['user']),
          );
          setState(() {
            posts.add(post);
            postsLoading = false;
          });
        }
      }
    });
    imagePostsCollection.snapshots().listen((event) {
      for (var doc in event.docs) {
        if (doc['text'].contains(searchController.text)) {
          Post post = ImagePost(
              postID: doc.id,
              text: doc['text'] ?? '',
              date: DateTime.fromMicrosecondsSinceEpoch(doc['date'].microsecondsSinceEpoch) ?? '',
              user: AppUser.WithUID(doc['user']),
              imageURL: doc['photoAddress'] ??
                  "https://www.indianhorizons.net/assets/lib/images/default.png");
          setState(() {
            posts.add(post);
            posts.shuffle();
            postsLoading = false;
          });
        }
      }
    });
    setState(() {
      postsLoading = false;
    });

  }

  searchUsers() {
    print("in search users, with search: " + searchController.text);
    setState(() {
      usersLoading = true;
    });
    users = [];
    CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');
    userCollection
        .snapshots()
        .listen((event) {
      for (var doc in event.docs) {
        String username = doc["username"];
        if (username.contains(searchController.text)) {
          AppUser appUser = AppUser(
            UID: doc["uid"] ??"",
            username: doc["username"]??"",
            email: doc["email"]??"",
            photoUrl: doc["photoUrl"]??"https://firebasestorage.googleapis.com/v0/b/cs310-project-cc354.appspot.com/o/unknown.jpg?alt=media&token=71503f0d-a3c9-4837-b2e0-30214a02f0e2",
            displayName: doc["displayName"]??"",
            bio: doc["bio"]??"",
            private: doc["private"]?? false,
          );
          setState(() {
            users.add(appUser);
            usersLoading = false;
          });
        }
      }
    });
    setState(() {
      usersLoading = false;
    });
  }
}
