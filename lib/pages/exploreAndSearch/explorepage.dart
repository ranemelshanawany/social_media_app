import 'package:flutter/material.dart';
import 'package:project_socialmedia/models/Comments.dart';
import 'package:project_socialmedia/models/User.dart';
import 'package:project_socialmedia/pages/exploreAndSearch/textPosts.dart';
import '../../utils/color.dart';
import 'package:animations/animations.dart';
import '../../models/Post.dart';
import 'postpage.dart';

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  List<bool> _selection = [true, false];

  static List<Comment> commentsList = [
    Comment(
        content: "I agree!",
        user: User(
            username: "username2",
            photoUrl:
                "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png")),
    Comment(
        content: "The best",
        user: User(
            username: "username3",
            photoUrl:
                "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png")),
  ];

  List<ImagePost> imagePosts = List.generate(
      30,
      (_) => ImagePost(
          text: "My dog is so cute!",
          date: "1w",
          likes: 65,
          comments: 2,
          imageURL: "https://picsum.photos/id/237/400",
          commentsList: commentsList,
      user: User(
          username: "username",
          photoUrl:
          "https://i.pinimg.com/originals/39/1e/e1/391ee12077ba9cabd10e476d8b8c022b.jpg")));

  List<Post> Posts = List.generate(
      10, (_) => Post(text: "This is a text post", date: "2d", likes: 4, comments: 2, commentsList: commentsList,
      user: User(
          username: "username",
          photoUrl:
          "https://i.pinimg.com/originals/39/1e/e1/391ee12077ba9cabd10e476d8b8c022b.jpg")));

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        _buildSearchBar(),
        _buildToggleButton(size),
        _buildContentDisplay(size)
      ],
    );
  }

  _buildSearchBar() {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed('/explore/search');
      },
      child: Container(
        height: 50,
        margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey[300],
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: Colors.grey[700],
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "Search",
              style: TextStyle(color: Colors.grey[700]),
            )
          ],
        ),
      ),
    );
  }

  _buildToggleButton(Size size) {
    return ToggleButtons(
      children: [
        _buildToggleWidget(size, "Images"),
        _buildToggleWidget(size, "Text")
      ],
      isSelected: _selection,
      onPressed: (int index) {
        setState(() {
          _selection[index] = true;
          if (index == 0) _selection[1] = false;
          if (index == 1) _selection[0] = false;
        });
      },
      color: AppColors.primary,
      selectedColor: Colors.white,
      fillColor: AppColors.primary,
      borderRadius: BorderRadius.circular(18),
      borderColor: AppColors.primary,
    );
  }

  _buildToggleWidget(Size size, String text) {
    return Container(
        width: (size.width - 36) / 2, child: Center(child: Text(text)));
  }

  _buildContentDisplay(Size size) {
    if (_selection[0]) //images selected
    {
      return Expanded(
        child: Container(
          padding: EdgeInsets.all(8),
          height: (200 * imagePosts.length).toDouble(),
          child: GridView.count(
            children: List.generate(
                imagePosts.length,
                (indexx) => OpenContainer(
                      openBuilder: (context, index) =>
                          PostPage(imagePosts[indexx]),
                      closedBuilder: (context, VoidCallback openContainer) =>
                          _buildGridItem(indexx, openContainer),
                      transitionType: ContainerTransitionType.fade,
                      transitionDuration: Duration(seconds: 1),
                    )),
            crossAxisCount: 3,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
          ),
        ),
      );
    } else //text posts selected
    {
      return Expanded(
        child: Container(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: Posts.length,
              itemBuilder: (context, index) => TextPostCard(Posts[index])),
        ),
      );
    }
  }

  _buildGridItem(int index, Function openContainer) {
    return Container(
      width: 200,
      height: 200,
      child: Card(
        margin: EdgeInsets.all(0),
        elevation: 0,
        child: InkWell(
          onTap: openContainer, //TODO Open post page,
          child: Image.network(imagePosts[index].imageURL),
        ),
      ),
    );
  }
}
