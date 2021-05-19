import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import '../../models/Notifications.dart';
import 'NotificationCard.dart';

class NotificationsPage extends StatefulWidget {

  const NotificationsPage({this.analytics,this.observer});

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _NotificationsState createState() => _NotificationsState();
}

List <String> users =['timmyturner1', 'sasukee', 'kim.possible', 'sandy1234', 'realjohnnybravo', 'ickyvicky', 'agent_p'];
List <String> avatarURLs =[
  'https://64.media.tumblr.com/80d49aa9c3feb0c44e911e6bc0564f57/tumblr_poffei5gem1w9meb1_540.jpg',
  'https://pbs.twimg.com/media/CR2mwYGWsAAkEcs.jpg',
  'https://64.media.tumblr.com/0b4efddda44b92aa600275a2029243d9/tumblr_pm5fr8r0mx1vt10pl_500.jpg',
  'https://i.pinimg.com/originals/89/e1/23/89e123ed7fae5caa265cb6d4ac675da8.png',
  'https://pbs.twimg.com/profile_images/2519861683/3hec14ac0k5178ouzeko_400x400.jpeg',
  'https://i.pinimg.com/originals/86/33/17/8633173f0a5766c853c0db727a84dbc4.png',
  'https://i.pinimg.com/originals/d2/f7/62/d2f762cb45b347768b6a569e2d20307a.png'
];

List <Notifications> notifications =[
  Notifications(avatar: NetworkImage(avatarURLs[0]), username: users[0], type: NotificationType.followBack, date: '8m'),
  Notifications(avatar: NetworkImage(avatarURLs[1]), username: users[1], type: NotificationType.message, date: '3h'),
  Notifications(avatar: NetworkImage(avatarURLs[2]), username: users[2], type: NotificationType.like, date: '2d'),
  Notifications(avatar: NetworkImage(avatarURLs[3]), username: users[3], type: NotificationType.comment, date: '3d'),
  Notifications(avatar: NetworkImage(avatarURLs[4]), username: users[4], type: NotificationType.reshare, date: '4d'),
  Notifications(avatar: NetworkImage(avatarURLs[5]), username: users[5], type: NotificationType.newFollow, date: '1w'),
  Notifications(avatar: NetworkImage(avatarURLs[6]), username: users[6], type: NotificationType.followBack, date: '2w'),

];

class _NotificationsState extends State<NotificationsPage> {

  String _message = '';

  void setMessage(String msg){
    setState(() {
      _message = msg;
    });
  }
  Future<void> _setLogEvent() async {
    await widget.analytics.logEvent(
        name: 'Notifications_Page',
        parameters: <String, dynamic>{
          'string': 'notifications'
        }
    );
    setMessage('Notifications page log event succeeded');
  }

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
