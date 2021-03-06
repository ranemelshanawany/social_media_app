import 'package:flutter/material.dart';
import 'package:project_socialmedia/utils/color.dart';
import '../../models/Post.dart';
import 'package:intl/intl.dart';

class PostCard extends StatelessWidget {

  final Post post;
  final Function delete;
  PostCard({ this.post, this.delete });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(0, 8.0, 0.0, 8.0),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              post.text,
              style: TextStyle(
                fontFamily: 'BrandonText',
                fontSize: 20.0,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
                //color: AppColors.textColor,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  DateFormat.yMd().format(post.date ==null? DateTime.now(): post.date),
                  style: TextStyle(
                    fontFamily: 'BrandonText',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),

                SizedBox(width: 6.0),

                Icon(
                  Icons.thumb_up,
                  size: 16.0,
                  color: AppColors.primary,
                ),
                Text(
                  '${post.likes}',
                  style: TextStyle(
                    fontFamily: 'BrandonText',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),

                SizedBox(width: 6.0),

                Icon(
                  Icons.comment,
                  size: 16.0,
                ),

                Text(
                  '${post.comments}',
                  style: TextStyle(
                    fontFamily: 'BrandonText',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),

                SizedBox(width: 12.0),

                IconButton(
                  icon: Icon(
                    Icons.delete,
                    size: 16.0,
                    color: Colors.red,
                  ),
                  onPressed: delete,
                )

              ],
            ),
          ],
        ),
      ),
    );
  }
}