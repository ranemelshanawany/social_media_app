import 'package:flutter/material.dart';
import 'package:project_socialmedia/models/User.dart';

import '../otherUserProfile.dart';

class UsersSearchCard extends StatefulWidget {

  AppUser user;

  UsersSearchCard(this.user);

  @override
  _UsersSearchCardState createState() => _UsersSearchCardState();
}

class _UsersSearchCardState extends State<UsersSearchCard> {
  @override
  Widget build(BuildContext context) {
    return  _buildUser();
  }

  _buildUser()
  {
    return Container(
      padding: EdgeInsets.all(10),
      child: InkWell(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileBuilder(widget.user)),
          );
        },
        child: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(widget.user.photoUrl == null?
            "https://i.pinimg.com/originals/39/1e/e1/391ee12077ba9cabd10e476d8b8c022b.jpg"
                : widget.user.photoUrl),),
            SizedBox(width: 10,),
            Text(widget.user.username, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
          ],
        ),
      ),
    );
  }
}
