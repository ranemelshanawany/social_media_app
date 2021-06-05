import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//enum NotificationType {followBack, message, like, comment, re-share, newFollow}

class Notifications{

  String userID;
  String profilePic;
  String username;
  String notificationType;
  String notificationCont;
  String postID;
  String mediaURL;
  Timestamp date;

  Notifications({this.userID, this.profilePic, this.username, this.notificationType, this.notificationCont, this.postID, this.mediaURL, this.date});

  Notifications.fromJson(Map<String, dynamic> json) {
    userID = json['userID'];
    profilePic = json['profilePic'];
    username = json['username'];
    notificationType = json['notificationType'];
    notificationCont = json['notificationCont'];
    postID = json['postID'];
    mediaURL = json['mediaURL'];
    date = json['date'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userID'] = this.userID;
    data['profilePic'] = this.profilePic;
    data['username'] = this.username;
    data['notificationType'] = this.notificationType;
    data['notificationCont'] = this.notificationCont;
    data['postID'] = this.postID;
    data['mediaURL'] = this.mediaURL;
    data['date'] = this.date;
    return data;
  }
}

