import 'package:flutter/material.dart';

class Notifications{

  NetworkImage avatar;
  String username;
  String type;
  DateTime date;

  Notifications({this.avatar, this.username, this.type, this.date})
  {
    // constructor
  }

}

/*
class FollowNotifications extends Notifications{

  notificationType = "is now following you";

FollowNotifications({avatar, username, notificationType, date, followButton}):
    super(avatar: avatar, username: username, notificationType: notificationType, date: date, followButton: followButton);

}

class MessageNotifications extends Notifications{

  IconButton messageButton;

  MessageNotifications(){
    //constructor
  }
}

class CommentNotifications extends Notifications{

  IconButton messageButton;

  CommentNotifications({this.messageButton}){
    //constructor
  }
}

class LikeNotifications extends Notifications{

  IconButton messageButton;

  LikeNotifications(){
    //constructor
  }
}

class ShareNotifications extends Notifications{

  IconButton messageButton;

  ShareNotifications(){
    //constructor
  }

 */
