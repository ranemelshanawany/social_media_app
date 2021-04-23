import 'package:flutter/material.dart';
import 'package:project_socialmedia/pages/editProfile.dart';
import 'package:project_socialmedia/utils/color.dart';
import 'package:project_socialmedia/pages/feed/feedpage.dart';
import 'package:project_socialmedia/pages/feed/newpostpage.dart';
import 'pages/bottomNavigationWidget.dart';
import 'pages/exploreandsearch/searchpage.dart';
import 'pages/loginSignupWelcome/walkthrough.dart';
import 'pages/loginSignupWelcome/signup.dart';
import 'pages/loginSignupWelcome/login_screen.dart';
import 'pages/loginSignupWelcome/welcome.dart';
import 'utils/shared_prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await MySharedPreferences.init();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
        '/editProfile' : (context) => EditProfilePage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }

  String getInitialRoute()
  {
    if (openedBefore) {
      if (loggedIn)
        return '/navigation';
      return '/welcome';
    }
    return '/walkthrough';
  }

}
