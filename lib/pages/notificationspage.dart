import 'package:flutter/material.dart';
import 'package:project_socialmedia/models/Notifications.dart';
import 'package:project_socialmedia/NotificationCard.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

List <String> users =['timmyturner1', 'sasukee', 'kim.possible', 'sandy1234', 'realjohnnybravo',];
List <String> avatarURLs =[
  'https://64.media.tumblr.com/80d49aa9c3feb0c44e911e6bc0564f57/tumblr_poffei5gem1w9meb1_540.jpg',
  'https://pbs.twimg.com/media/CR2mwYGWsAAkEcs.jpg',
  'https://64.media.tumblr.com/0b4efddda44b92aa600275a2029243d9/tumblr_pm5fr8r0mx1vt10pl_500.jpg',
  'https://i.pinimg.com/originals/89/e1/23/89e123ed7fae5caa265cb6d4ac675da8.png',
  'https://pbs.twimg.com/profile_images/2519861683/3hec14ac0k5178ouzeko_400x400.jpeg',
];

List <Notifications> notifications =[
  //Notifications(avatar: NetworkImage(avatarURLs[0]), username: users[0], type: 'is now following you.', date: DateTime.now()),
  //Notifications(avatar: NetworkImage(avatarURLs[1]), username: users[1], type: 'is now following you.', date: DateTime.now()),
  //Notifications(avatar: NetworkImage(avatarURLs[2]), username: users[2], type: 'is now following you.', date: DateTime.now()),
  //Notifications(avatar: NetworkImage(avatarURLs[3]), username: users[3], type: 'is now following you.', date: DateTime.now()),
  //Notifications(avatar: NetworkImage(avatarURLs[4]), username: users[4], type: 'is now following you.', date: DateTime.now()),
];

class _NotificationsState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          children: <Widget>[
            Column(
            children: notifications.map((notification) => NotificationCard(
              notification: notification,
            )).toList(),
          ),
          ]
        ),
      ),
    );
  }
}
