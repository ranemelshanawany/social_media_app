import 'package:project_socialmedia/models/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class PostList extends StatefulWidget {
  const PostList({Key key}) : super(key: key);

  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList>{
  @override
  Widget build(BuildContext context){

    final users = Provider.of<List<AppUser>>(context);

    print(users.toString());

    /*
    return Container(
      child: Text(users.toString()),
    );
    */
  }
}

