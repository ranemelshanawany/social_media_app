import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import '../../models/Notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'notificationCard.dart';
import 'package:project_socialmedia/services/database.dart';
import 'package:project_socialmedia/pages/notifications/notificationStreamWrap.dart';

class NotificationsPage extends StatefulWidget {

  const NotificationsPage({this.analytics,this.observer});

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setLogEvent();
    _setCurrentScreen();
  }

  Future<void> _setCurrentScreen() async{
    await widget.analytics.setCurrentScreen(
        screenName: 'Notifications_Page',
        screenClassOverride: 'Notifications_Page'

    );
  }

  Future<void> _setLogEvent() async{
    await widget.analytics.logEvent(
        name: 'Notifications_Page',
        parameters: <String,dynamic> {
          'string': 'notifications'
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          children: <Widget>[
            Column(
            children: [
              getNotifications(),
            ],
          ),
          ]
        ),
      ),
    );
  }
}
  getNotifications() {
    return NotificationStreamWrapper(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        stream: DatabaseService(uid: firebaseAuth.currentUser.uid).notificationCollection
            .doc(firebaseAuth.currentUser.uid)
            .collection('notifications')
            .orderBy('date', descending: true)
            .limit(20)
            .snapshots(),
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (_, DocumentSnapshot snapshot) {
          Notifications notifications = Notifications.fromJson(snapshot.data());
          return NotificationCard(
            notifications: notifications
          );
        });
  }

  deleteAllItems() async {
    QuerySnapshot notificationsSnap = await DatabaseService(uid: firebaseAuth.currentUser.uid).notificationCollection
        .doc(firebaseAuth.currentUser.uid)
        .collection('notifications')
        .get();
    notificationsSnap.docs.forEach((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }
