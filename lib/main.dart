import 'package:flutter/material.dart';
import 'pages/walkthrough.dart';
import 'pages/signup.dart';
import 'pages/login_screen.dart';
import 'pages/welcome.dart';
import 'shared_prefs.dart';
import 'shared_prefs.dart';

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

  @override
  void initState() {
    super.initState();
    openedBefore = MySharedPreferences.getBooleanValue() ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: openedBefore? '/welcome': '/walkthrough',
      routes: {
        '/walkthrough': (context) => WalkThrough(),
        '/signup': (context) => SignUpScreen(),
        '/login': (context) => LoginScreen(),
        '/welcome': (context) => WelcomeScreen(),
      },
    );
  }
}
