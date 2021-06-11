import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project_socialmedia/models/User.dart';
import 'package:project_socialmedia/pages/exploreAndSearch/usersInSearch.dart';

class ConnectionsList extends StatefulWidget {
  final List<AppUser> users;

  ConnectionsList(this.users);

  @override
  _ConnectionsListState createState() => _ConnectionsListState(users);
}

class _ConnectionsListState extends State<ConnectionsList> {

  List<AppUser> users;

  _ConnectionsListState(this.users);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:  users.length == 0? Center(child: Text("None found")):
      Column(children: users.map((e) => UsersSearchCard(e)).toList(),)

      ),
    );
  }
}
