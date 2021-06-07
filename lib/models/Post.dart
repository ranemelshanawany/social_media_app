import 'Comments.dart';
import 'User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Post {
  String postID;
  String text;
  DateTime date;
  int likes;
  int comments;
  List<Comment> commentsList;
  AppUser user;

  Post({ this.text, this.date, this.likes, this.comments, this.commentsList, this.user, this.postID });
}

class ImagePost extends Post {
  String imageURL;

  ImagePost({ text, date, likes, comments, this.imageURL, commentsList, user , postID}):
    super(text: text, date: date, likes: likes, comments: comments, commentsList: commentsList, user: user, postID: postID);

}