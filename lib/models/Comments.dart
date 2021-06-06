import 'package:cloud_firestore/cloud_firestore.dart';

import 'User.dart';

class Comment
{
  AppUser userCommenting;
  AppUser userCommentedOn;
  String postID;
  String content;
  DateTime date;

  Comment({this.userCommentedOn, this.userCommenting, this.content, this.postID, this.date});
}