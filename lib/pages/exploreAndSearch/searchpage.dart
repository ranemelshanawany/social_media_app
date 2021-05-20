import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {

  const SearchPage({this.analytics,this.observer});

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  String _message = '';

  void setMessage(String msg){
    setState(() {
      _message = msg;
    });

  }

  Future<void> _setLogEvent() async{
    await widget.analytics.logEvent(
        name: 'Search_Page',
        parameters: <String,dynamic> {
          'string': 'search'
        }
    );
    setMessage('Search page log event succeeded');
  }

  Future<void> _setCurrentScreen() async{
    await widget.analytics.setCurrentScreen(
        screenName: 'Search_Page',
        screenClassOverride: 'Search_Page'

    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setLogEvent();
    _setCurrentScreen();
  }

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
