import 'package:flutter/material.dart';

enum NotificationType {follows, liked, commented, reshare, message}

class Notifications{

  NetworkImage avatar;
  String username;
  DateTime date;
  NotificationType type;

  Notifications({this.avatar, this.username, this.type, this.date})
  {
    // constructor
  }

}

