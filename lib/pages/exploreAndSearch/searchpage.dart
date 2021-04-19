import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  String query = "";
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar()
          ],
        ),
      ),
    );
  }

  _buildSearchBar() {
    return InkWell(
      child: Row(
        children: [
          IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: () {
            Navigator.of(context).pop();
          },
          padding: EdgeInsets.only(left: 10),),
          Expanded(
            flex: 1,
            child: Container(
              height: 50,
              margin: EdgeInsets.fromLTRB(0, 8, 8, 8),
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey[300],
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey[700],),
                  SizedBox(width: 5,),
                  Flexible(
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: "Search",
                      filled: false,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    autofocus: true,
                    onSubmitted: (value) {
                        print(value);
                    },),
                  ),
                  SizedBox(width: 5,),
                  IconButton(icon: Icon(Icons.close), onPressed: (){
                    searchController.clear();
                  },
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}
