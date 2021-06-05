import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:project_socialmedia/utils/color.dart';

Center circularProgress(context) {
  return Center(
    child: SpinKitFadingCircle(
      size: 40.0,
      color: AppColors.primary,
    ),
  );
}

Container linearProgress(context) {
  return Container(
    child: LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Theme.of(context).accentColor),
    ),
  );
}