import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_socialmedia/utils/color.dart';
import '../../models/Notifications.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:project_socialmedia/services/database.dart';
import 'notificationDetails.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:project_socialmedia/utils/indicator.dart';

class NotificationCard extends StatefulWidget {
  final Notifications notifications;

  NotificationCard({this.notifications});

  @override
  _NotificationCardState createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ObjectKey("${widget.notifications}"),
      background: stackBehindDismiss(),
      direction: DismissDirection.endToStart,
      onDismissed: (v) {
        delete();
      },
      child: Column(
        children: [
          ListTile(
            onTap: () {
              Navigator.of(context).push(CupertinoPageRoute(
                builder: (_) => NotificationDetails(notifications: widget.notifications),
              ));
            },
            leading: CircleAvatar(
              radius: 25.0,
              backgroundImage: NetworkImage(widget.notifications.profilePic),
            ),
            title: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                ),
                children: [
                  TextSpan(
                    text: '${widget.notifications.username} ',
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0),
                  ),
                  TextSpan(
                    text: buildTextConfiguration(),
                    style: TextStyle(fontSize: 10.0),
                  ),
                ],
              ),
            ),
            subtitle: Text(
              timeago.format(widget.notifications.date.toDate()),
            ),
            trailing: previewConfiguration(),
          ),
          Divider(),
        ],
      ),
    );
  }

  Widget stackBehindDismiss() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20.0),
      color: Theme.of(context).accentColor,
      child: Icon(
        CupertinoIcons.delete,
        color: Colors.white,
      ),
    );
  }

  delete() {
    DatabaseService(uid: firebaseAuth.currentUser.uid).notificationCollection
        .doc(firebaseAuth.currentUser.uid)
        .collection('notifications')
        .doc(widget.notifications.postID)
        .get()
        .then((doc) => {
      if (doc.exists)
        {
          doc.reference.delete(),
        }
    });
  }

  previewConfiguration() {
    if (widget.notifications.notificationType == "like" || widget.notifications.notificationType == "comment") {
      return buildPreviewImage();
    } else {
      return Text('');
    }
  }

  buildTextConfiguration() {
    if (widget.notifications.notificationType == "like") {
      return "liked your post";
    } else if (widget.notifications.notificationType == "follow") {
      return "is following you";
    } else if (widget.notifications.notificationType == "comment") {
      return "commented '${widget.notifications.notificationCont}'";
    } else {
      return "Error: Unknown type '${widget.notifications.notificationType}'";
    }
  }

  buildPreviewImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: CachedNetworkImage(
        imageUrl: widget.notifications.mediaURL,
        placeholder: (context, url) {
          return circularProgress(context);
        },
        errorWidget: (context, url, error) {
          return Icon(Icons.error);
        },
        height: 40.0,
        fit: BoxFit.cover,
        width: 40.0,
      ),
    );
  }
}