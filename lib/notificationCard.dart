import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_socialmedia/utils/color.dart';
import 'models/Notifications.dart';

class NotificationCard extends StatelessWidget {

  final Notifications notification;
  NotificationCard({this.notification});

  @override
  Widget build(BuildContext context) {
    return Card( // wrap it (padding) with widget
      margin:EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
      child: Padding(
        padding: EdgeInsets.all(14.0), // changes the size of card
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget> [
                CircleAvatar(
                  backgroundImage: notification.avatar,
                ),
              ],
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    notification.username,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: <Widget>[
                FlatButton(
                    color: Colors.blue,
                    onPressed: (){},
                    child: Text('Follow', style: TextStyle(color: Colors.white),)
                )
              ],
            ),
          ],
        )
      ),
    );
  }
}