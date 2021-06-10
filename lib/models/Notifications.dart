import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'User.dart';

//enum NotificationType {followBack, message, like, comment, re-share, newFollow}

class Notifications{

  AppUser owner;
  AppUser sender;
  String notificationType;
  String commentCont;
  String postID;
  DateTime date;

  Notifications({this.owner, this.sender, this.notificationType, this.commentCont, this.postID, this.date});

}

