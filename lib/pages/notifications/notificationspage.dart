import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_socialmedia/models/Notifications.dart';
import 'package:project_socialmedia/models/User.dart';
import 'package:project_socialmedia/pages/notifications/notificationWrapper.dart';
import 'package:project_socialmedia/services/database.dart';
import 'package:project_socialmedia/utils/color.dart';

import 'notificationCard.dart';

class NotificationsPage extends StatefulWidget {

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  Notifications notifications;

  NotificationsPage({this.analytics, this.observer});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {

  User user;
  AppUser appUser;

  @override
  Widget build(BuildContext context) {

    user = FirebaseAuth.instance.currentUser;
    appUser = AppUser.WithUID(user.uid);

    return Scaffold(
      body: ListView(
        children: [
          //NotificationWrapper(),
        ],
      ),
    );
  }

  getNotification() {

    CollectionReference notificationCollection = FirebaseFirestore.instance.collection('notifications');
    notificationCollection.where("owner", isEqualTo: user.uid).snapshots().listen((value) {
      for(var doc in value.docs)
      {

      }
    });
  }
}