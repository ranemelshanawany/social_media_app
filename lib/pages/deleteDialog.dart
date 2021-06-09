import 'package:flutter/material.dart';
import 'package:project_socialmedia/services/database.dart';

Future<void> showDeleteDialog(BuildContext context, String type, String uid, String postID) async {

  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete post'),
        content: Text('Are you sure you want to delete this post?'),
        actions: <Widget>[
          TextButton(
            child: Text('Yes'),
            onPressed: () {
              if(type == 'image')
                DatabaseService(uid: uid).deleteImagePost(postID);
              else
                DatabaseService(uid: uid).deleteTextPost(postID);
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}