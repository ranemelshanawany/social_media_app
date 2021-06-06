import 'package:flutter/material.dart';
import 'package:project_socialmedia/models/User.dart';

class UsersSearchCard extends StatelessWidget {

  AppUser user;

  UsersSearchCard(this.user);

  @override
  Widget build(BuildContext context) {
    return  _buildUser();
  }

  _buildUser()
  {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          CircleAvatar(backgroundImage: NetworkImage(user.photoUrl == null?
          "https://i.pinimg.com/originals/39/1e/e1/391ee12077ba9cabd10e476d8b8c022b.jpg"
              : user.photoUrl),),
          SizedBox(width: 10,),
          Text(user.username, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
        ],
      ),
    );
  }
}
