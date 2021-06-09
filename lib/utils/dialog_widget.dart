
import 'package:flutter/material.dart';

Future<void> showMyDialog({context, String title, String message, String closer, Function function}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(message),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(closer),
            onPressed: () {
              if(function != null)
                function();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}