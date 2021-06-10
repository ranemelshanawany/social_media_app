import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_socialmedia/pages/notifications/notificationCard.dart';

class NotificationWrapper extends StatelessWidget {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return NotificationCard();
        } else {
          return Container(
            child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 250.0),
              child: Text('No Recent Activities'),
            ),
          ),);
        }
      },
    );
  }
}