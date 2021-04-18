class Post {
  String text;
  String date;
  int likes;
  int comments;

  Post({ this.text, this.date, this.likes, this.comments });
}

class ImagePost extends Post {
  String imageURL;

  ImagePost({ text, date, likes, comments, this.imageURL }):
    super(text: text, date: date, likes: likes, comments: comments);

}