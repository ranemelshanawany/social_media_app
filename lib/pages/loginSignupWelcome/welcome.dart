import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import '../../utils/background.dart';
import '../../utils/color.dart';
import '../../utils/styles.dart';
import '../../utils/shared_prefs.dart';


class WelcomeScreen extends StatefulWidget {

  const WelcomeScreen({this.analytics,this.observer});

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  Future<void> _setLogEvent() async{
    await widget.analytics.logEvent(
        name: 'Welcome_Page',
        parameters: <String,dynamic> {
          'string': 'Welcome_Page'
        }
    );
  }

  Future<void> _setCurrentScreen() async{
    await widget.analytics.setCurrentScreen(
        screenName: 'Welcome_Page',
        screenClassOverride: 'Welcome_Page'

    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setLogEvent();
    _setCurrentScreen();
    MySharedPreferences.setWalkthroughBooleanValue(true);
    print(MySharedPreferences.getWalkthroughBooleanValue());
    MySharedPreferences.setLoginBooleanValue(false);
  }


  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;

    return Scaffold(
      body: Background(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Welcome",
              style: titleWelcome,
            ),
            SizedBox(height: size.height *0.05),
            //SvgPicture.asset("")
            _buildRoundedButton(
              size: size,
              text:"LOGIN",
              color: AppColors.primary,
              textColor: Colors.white,
              press: () {
                Navigator.of(context).pushNamed("/login");
              } ,
            ),
            _buildRoundedButton(
              size: size,
              text:"Sign Up",
              color: AppColors.secondary,
              textColor: AppColors.textColor,
              press: () {
                Navigator.of(context).pushNamed("/signup");
              } ,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundedButton({Size size, String text, Function press, Color color,Color textColor})
  {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: FlatButton(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          color: color,
          onPressed: press,
          child: Text(
            text,
            style: TextStyle(color: textColor),
          ),
        ),
      ),
    );
  }

}