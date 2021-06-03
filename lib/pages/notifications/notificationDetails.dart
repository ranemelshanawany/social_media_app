
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:project_socialmedia/models/Notifications.dart';
import 'package:project_socialmedia/pages/profile/profilepage.dart';
import 'package:project_socialmedia/utils/indicator.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationDetails extends StatefulWidget {
  final Notifications notifications;

  NotificationDetails({this.notifications});

  @override
  _NotificationDetailsState createState() => _NotificationDetailsState();
}

class _NotificationDetailsState extends State<NotificationDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.keyboard_backspace),
        ),
      ),
      body: ListView(
        children: [
          buildImage(context),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
            leading: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) =>
                          Profile(profileID: widget.notifications.userID),
                    ));
              },
              child: CircleAvatar(
                radius: 25.0,
                backgroundImage: NetworkImage(widget.notifications.profilePic),
              ),
            ),
            title: Text(
              widget.notifications.username,
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            subtitle: Row(
              children: [
                Icon(Feather.clock, size: 13.0),
                SizedBox(width: 3.0),
                Text(
                  timeago.format(widget.notifications.date.toDate()),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              widget.notifications?.notificationCont ?? "",
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }

  buildImage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: CachedNetworkImage(
          imageUrl: widget.notifications.mediaURL,
          placeholder: (context, url) {
            return circularProgress(context);
          },
          errorWidget: (context, url, error) {
            return Icon(Icons.error);
          },
          height: 400.0,
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }
}