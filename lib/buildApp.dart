import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
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

  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);


  @override
  void initState() {
    super.initState();
    openedBefore = MySharedPreferences.getWalkthroughBooleanValue() ?? false;
    loggedIn = MySharedPreferences.getLoginBooleanValue() ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
            navigatorObservers: <NavigatorObserver>[observer],
            initialRoute: getInitialRoute(),
            theme: ThemeData(primaryColor: AppColors.primary),
            routes: {
              '/walkthrough': (context) => WalkThrough(analytics: analytics,observer: observer),
              '/signup': (context) => SignUpScreen(analytics: analytics,observer: observer),
              '/login': (context) => LoginScreen(analytics: analytics,observer: observer),
              '/welcome': (context) => WelcomeScreen(analytics: analytics,observer: observer),
              '/navigation': (context) => BottomNavigator(analytics: analytics,observer: observer),
              '/explore/search': (context) => SearchPage(analytics: analytics,observer: observer),
              '/newpost': (context) => NewPost(analytics: analytics,observer: observer),
              '/feed': (context) => Feed(analytics: analytics,observer: observer),
              '/editProfile': (context) => EditProfilePage(analytics: analytics,observer: observer),
            },
            debugShowCheckedModeBanner: false,
          );
  }

  String getInitialRoute() {
    if (openedBefore) {
      if (loggedIn) return '/navigation';
      return '/welcome';
    }
    // FirebaseCrashlytics.instance.crash(); // will crash the currently running application.
    // Need to manually re-run your application on your emulator for Crashlytics to submit the crash report.
    return '/walkthrough';
  }
}
