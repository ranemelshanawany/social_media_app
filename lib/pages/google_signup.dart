import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_socialmedia/utils/dialog_widget.dart';

class GoogleSignUp extends StatefulWidget {
  @override
  _GoogleSignUpState createState() => _GoogleSignUpState();
}

class _GoogleSignUpState extends State<GoogleSignUp> {
  ImageProvider googleLogo = AssetImage("assets/icons/google.png");
  Size size;

  FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    Widget gooogleSignUpButton = _buildGoogleSignUpButton();
    return gooogleSignUpButton;
  }

  Widget _buildGoogleSignUpButton() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: FlatButton(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        color: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(29),
            side: BorderSide(color: Colors.grey)),
        onPressed: () async {
          signInWithGoogle();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image(
              image: googleLogo,
              width: 20,
            ),
            Expanded(
              child: Center(
                child: Text(
                  "Connect with Google",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void signInWithGoogle() async {
    try{
      GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      UserCredential userCredential = (await auth.signInWithCredential(credential));
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/navigation', (Route<dynamic> route) => false);
    } on FirebaseException catch (e) {
      showMyDialog(title: "Google connection failed", context: context, closer: "Ok", message: e.message);
    }
  }
}
