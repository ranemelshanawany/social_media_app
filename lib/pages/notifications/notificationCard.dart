import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_socialmedia/models/User.dart';
import 'package:project_socialmedia/utils/color.dart';
import '../../models/Notifications.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationCard extends StatefulWidget {

  final Notifications notifications;

  NotificationCard(this.notifications);

  @override
  _NotificationCardState createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {

  Notifications notification;

  User user;
  AppUser appUser;

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
                  _buildsenderImage(),
                  SizedBox(
                    width:200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8.0,0.0,0.0,0.0),
                          child: _buildTextContent(),
                    ),
                  ],
                ),
              ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      _buildInteractiveContent(),
                ],
              ),
            ],
          )
      ]),
    ));
  }

  Widget _buildsenderImage(){
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: CircleAvatar(
        backgroundImage: notification.sender.photoUrl == null? NetworkImage(notification.sender.photoUrl): AssetImage('assets/images/John.jpeg'),
        radius: 26.0,
      ),
    );
  }

  Widget _buildTextContent(){

    String notificationContent;

    if(notification.notificationType == "follow"){

      notificationContent = " is now following you.";
    }
    else if(notification.notificationType == "like"){

      notificationContent = " liked your post.";
    }
    else if(notification.notificationType == "comment"){

      notificationContent = " commented on your post.";

    }
    else if(notification.notificationType == "request"){

      notificationContent = " wants to follow you.";
    }

    return RichText(
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                  text: notification.sender.username,
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor)
              ),
              TextSpan(
                  text: notificationContent + ' ',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColor)
              ),
              TextSpan(text: timeago.format(notification.date),
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600])
              ),
            ]
        )
    );
  }

  Widget _buildInteractiveContent(){

    if(notification.notificationType== "follow"){
      return Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
        child: OutlineButton(
            color: Colors.white,
            onPressed: (){},
            child: Text('Following')
        ),
      );
    }
    else if(notification.notificationType == "like"){
      return Padding(
        padding: const EdgeInsets.fromLTRB(52.0, 0.0, 0.0, 0.0),
        child: SizedBox(
          height: 52.0,
          width: 52.0,
          child: Image(
              image: NetworkImage(
                'https://i.pinimg.com/originals/a2/e2/62/a2e262ea209788c48cb41d8696b29ea4.jpg',
              )),
        ),
      );
    }
    else if(notification.notificationType == "comment"){
      return Padding(
        padding: const EdgeInsets.fromLTRB(52.0, 0.0, 0.0, 0.0),
        child: SizedBox(
          height: 52.0,
          width: 52.0,
          child: Image(
              image: NetworkImage(
                'https://i.pinimg.com/originals/a2/e2/62/a2e262ea209788c48cb41d8696b29ea4.jpg',
              )),
        ),
      );
    }
    else if(notification.notificationType == "request"){
      return Padding(
        padding: const EdgeInsets.fromLTRB(52.0, 0.0, 0.0, 0.0),
        child: SizedBox(
          height: 52.0,
          width: 52.0,
          child: Image(
              image: NetworkImage(
                'https://i.pinimg.com/originals/a2/e2/62/a2e262ea209788c48cb41d8696b29ea4.jpg',
              )),
        ),
      );
    }

  }
}