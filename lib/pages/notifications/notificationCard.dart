import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_socialmedia/utils/color.dart';
import '../../models/Notifications.dart';

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
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: CircleAvatar(
                    backgroundImage: notification.avatar,
                    radius: 26.0,
                  ),
                ),
              ],
            ),
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
      ),
    );
  }

  Widget _buildTextContent(){

    String notificationContent;

    if(notification.type == NotificationType.followBack){

      notificationContent = " is now following you.";
    }
    else if(notification.type == NotificationType.message){

      notificationContent = " sent you a new message.";
    }
    else if(notification.type == NotificationType.like){

      notificationContent = " liked your post.";
    }
    else if(notification.type == NotificationType.comment){

      notificationContent = " commented on your post.";

    }
    else if(notification.type == NotificationType.reshare){

      notificationContent = " reshared your post.";
    }
    else
      notificationContent = " is now following you.";

    return RichText(
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
          text: notification.username,
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
          TextSpan(text: notification.date,
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

    if(notification.type == NotificationType.followBack){

      return Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
        child: OutlineButton(
            color: Colors.white,
            onPressed: (){},
            child: Text('Following')
        ),
      );
    }
    else if(notification.type == NotificationType.message){

      return Padding(
        padding: const EdgeInsets.fromLTRB(54.0, 0.0, 0.0, 0.0),
        child: IconButton(
            onPressed: (){},
            icon: Icon(Icons.chat, color: AppColors.primary, size: 34.0),
        ),
      );
    }
    else if(notification.type == NotificationType.like){

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
    else if(notification.type == NotificationType.comment){

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
    else if(notification.type == NotificationType.reshare){

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
    else{

      return Padding(
        padding: const EdgeInsets.fromLTRB(18.0, 0.0, 0.0, 0.0),
        child: FlatButton(
            color: Colors.blue,
            onPressed: (){},
            child: Text('Follow', style: TextStyle(color: Colors.white,))
        ),
      );

    }



  }

}