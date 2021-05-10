import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_socialmedia/utils/shared_prefs.dart';
import 'pages/feed/feedpage.dart';
import 'pages/feed/newpostpage.dart';
import 'pages/bottomNavigationWidget.dart';
import 'pages/exploreandsearch/searchpage.dart';
import 'pages/loginSignupWelcome/walkthrough.dart';
import 'pages/loginSignupWelcome/signup.dart';
import 'pages/loginSignupWelcome/login_screen.dart';
import 'pages/loginSignupWelcome/welcome.dart';
import 'pages/profile/editProfile.dart';
import 'utils/color.dart';

class BuildApp extends StatefulWidget {
  @override
  _BuildAppState createState() => _BuildAppState();
}

class _BuildAppState extends State<BuildApp> {

  bool openedBefore = false;
  bool loggedIn = false;

  @override
  void initState() {
    super.initState();
    openedBefore = MySharedPreferences.getWalkthroughBooleanValue() ?? false;
    loggedIn = MySharedPreferences.getLoginBooleanValue() ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
            initialRoute: getInitialRoute(),
            theme: ThemeData(primaryColor: AppColors.primary),
            routes: {
              '/walkthrough': (context) => WalkThrough(),
              '/signup': (context) => SignUpScreen(),
              '/login': (context) => LoginScreen(),
              '/welcome': (context) => WelcomeScreen(),
              '/navigation': (context) => BottomNavigator(),
              '/explore/search': (context) => SearchPage(),
              '/newpost': (context) => NewPost(),
              '/feed': (context) => Feed(),
              '/editProfile': (context) => EditProfilePage(),
            },
            debugShowCheckedModeBanner: false,
          );
  }

  String getInitialRoute() {
    if (openedBefore) {
      if (loggedIn) return '/navigation';
      return '/welcome';
    }
    return '/walkthrough';
  }
}
