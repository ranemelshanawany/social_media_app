import 'package:flutter/material.dart';

enum NotificationType {followBack, message, like, comment, reshare, newFollow}

class Notifications{

  NetworkImage avatar;
  String username;
  String date;
  NotificationType type;

  Notifications({this.avatar, this.username, this.type, this.date})
  {
    // constructor
  }

}

