import 'package:flutter/material.dart';
import 'package:project_socialmedia/utils/styles.dart';
import '../utils/background.dart';
import '../utils/color.dart';
import '../utils/Post.dart';
import 'package:project_socialmedia/postCard.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  int postCount = 0;

  List<Post> posts = [
    Post(text: 'First post', date: '18 April 21', likes: 50, comments: 5),
    Post(text: 'Second post', date: '20 April 21', likes: 35, comments: 15),
    Post(text: 'Third post', date: '21 April', likes: 45, comments: 17),
  ];

  void buttonPressed() {
    setState(() {
      postCount += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],

        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primary,
          child: Icon(Icons.add),
          onPressed: buttonPressed,
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 0.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/John.jpeg'),
                    radius: 40.0,
                  ),

                  SizedBox(width: 8,),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      Text(
                        'John F.',
                        style: TextStyle(
                          fontFamily: 'BrandonText',
                          fontSize: 28.0,
                          fontWeight: FontWeight.w500,
                          color: AppColors.headingColor,
                        ),
                      ),

                      SizedBox(height: 10.0,),

                      Text(
                        '@JohnF',
                        style: TextStyle(
                          fontFamily: 'BrandonText',
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColor,
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
                            'JohnF@gmail.com',
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

                ],
              ),

              Divider(
                color: AppColors.primary,
                height: 30,
                thickness: 2.0,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        'Posts',
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontFamily: 'BrandonText',
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      Text(
                        '$postCount',
                        style: TextStyle(
                          fontFamily: 'BrandonText',
                          fontSize: 24.0,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        'Followers',
                        style: TextStyle(
                          fontFamily: 'BrandonText',
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColor,
                        ),
                      ),

                      Text(
                        '215',
                        style: TextStyle(
                          fontFamily: 'BrandonText',
                          fontSize: 24.0,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        'Following',
                        style: TextStyle(
                          fontFamily: 'BrandonText',
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColor,
                        ),
                      ),

                      Text(
                        '679',
                        style: TextStyle(
                          fontFamily: 'BrandonText',
                          fontSize: 24.0,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              Divider(
                color: AppColors.primary,
                height: 30,
                thickness: 2.0,
              ),

              Column(
                children: posts.map((post) => PostCard(
                    post: post,
                    delete: () {
                      setState(() {
                        posts.remove(post);
                      });
                    }
                )).toList(),
              ),
            ],
          ),
        )
    );
  }
}

