import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_socialmedia/utils/color.dart';
import 'exploreandsearch/explorepage.dart';
import 'feedpage.dart';
import 'notificationspage.dart';
import 'profilepage.dart';
import '../utils/shared_prefs.dart';

class BottomNavigator extends StatefulWidget {
  @override
  _BottomNavigatorState createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {

  DateTime currentBackPressTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    MySharedPreferences.setLoginBooleanValue(true);
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    final List<Widget> _widgetOptions = <Widget>[
      Feed(),
      Explore(),
      Notifications(),
      Profile(),
    ];

    final List<Widget> appBars = [
      AppBar(title: Center(child: Text("Feed")), backgroundColor: AppColors.primary,),
      AppBar(title: Center(child: Text("Explore")), backgroundColor: AppColors.primary,),
      AppBar(title: Center(child: Text("Notifications")), backgroundColor: AppColors.primary,),
      AppBar(title: Center(child: Text("Profile")), backgroundColor: AppColors.primary,),
    ];


    return Scaffold(
      appBar: appBars[_selectedIndex],
      backgroundColor: Colors.grey[100],
      body: WillPopScope(child :_widgetOptions[_selectedIndex], onWillPop: onWillPop),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.primary,
        selectedFontSize: 17,
        iconSize: 30,
        items: [

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: ""
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: ""
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: ""
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded ),
            label: ""
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.white,
        selectedLabelStyle: TextStyle(fontSize: 16.0),
        //showUnselectedLabels: false,
      ),
    );
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Press back again to exit");
      return Future.value(false);
    }
    return Future.value(true);
  }
 }
