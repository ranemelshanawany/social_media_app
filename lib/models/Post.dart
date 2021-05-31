import 'Comments.dart';
import 'User.dart';

class Post {
  String text;
  String date;
  int likes;
  int comments;
  List<Comment> commentsList;
  AppUser user;

  Post({ this.text, this.date, this.likes, this.comments, this.commentsList, this.user });
}

class ImagePost extends Post {
  String imageURL;

  ImagePost({ text, date, likes, comments, this.imageURL, commentsList, user }):
    super(text: text, date: date, likes: likes, comments: comments, commentsList: commentsList, user: user);

}