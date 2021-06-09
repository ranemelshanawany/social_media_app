import 'package:flutter/material.dart';

Future<void> showReportDialog(BuildContext context, String item, Function function) async {

  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Report ' + item),
        content: Text('Are you sure you want to report this $item?'),
        actions: <Widget>[
          TextButton(
            child: Text('Yes'),
            onPressed: () {
              function();
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