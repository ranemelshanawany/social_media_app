import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_socialmedia/utils/dialog_widget.dart';
import '../../utils/styles.dart';
import '../../utils/background.dart';
import '../../utils/color.dart';
import 'package:email_validator/email_validator.dart';

import '../google_signup.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  bool _isObscured = true;

  String mail;
  String pass;
  String name;
  String Username;
  String pass2;
  final _formKey = GlobalKey<FormState>();

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> signUpUser() async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: mail, password: pass);
      print(userCredential);
      var user = FirebaseAuth.instance.currentUser;
      user.updateProfile(
        displayName: name,
      );
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/navigation', (Route<dynamic> route) => false);
    } on FirebaseAuthException catch (e) {
      showMyDialog(title: "Cannot Sign Up", context: context, closer: "Ok", message: e.message);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    auth.authStateChanges().listen((User user) {
      if (user == null)
        print("User is signed out");
      else {
        print("User is signed in");
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    Widget confirmPasswordInput = _buildConfirmPasswordFormField(size);
    Widget passwordInput = _buildPasswordFormField(size);
    Widget emailInput = _buildEmailFormField(size);
    Widget UsernameInput = _buildUsernameFormField(size);
    Widget nameInput = _buildNameFormField(size);
    Widget signupButton = _buildSignUpButton(size);

    return Scaffold(
      body: Background(
        child: Center(
          child: Container(
            width: size.width,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: () {Navigator.pop(context);}, padding: EdgeInsets.all(0),),
                      Text(
                        "SIGNUP",
                        style: labelSignup,
                      ),
                      SizedBox(width: 50,)
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          nameInput,
                          SizedBox(
                            height: 10,
                          ),
                          UsernameInput,
                          SizedBox(
                            height: 10,
                          ),
                          emailInput,
                          SizedBox(
                            height: 10,
                          ),
                          passwordInput,
                          SizedBox(
                            height: 10,
                          ),
                          confirmPasswordInput,
                          SizedBox(
                            height: 10,
                          ),
                          signupButton
                        ],
                      ),
                    ),
                  ),
                  Text("Or"),
                  GoogleSignUp(),
                  _buildLoginText(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpButton(Size size) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: TextButton(onPressed: () {
          if (_formKey.currentState.validate())
          {
            _formKey.currentState.save();
            signUpUser();
            //TODO add actual signup
          }
        },
          child: Text("SIGNUP", style: buttonSignup,),
          style: TextButton.styleFrom(backgroundColor: AppColors.primary,  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),),
        ),
      ),
    );
  }

  Widget _buildNameFormField(Size size) {

    Function validateName = ((val) {
      return val.isEmpty
          ? "Please enter a name"
          : null;
    });

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: TextFormField(
          decoration: nameInputDecoration,
          validator: validateName,
          onSaved: (value) {
            setState(() {
              name = value;
            });}
      ),
    );
  }

  Widget _buildUsernameFormField(Size size) {

    Function validateName = ((val) {
      return val.isEmpty
          ? "Please enter a username"
          : null;
    });

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: TextFormField(
        decoration: UsernameInputDecoration,
        validator: validateName,
        onSaved: (value) {
          setState(() {
            Username = value;
          });
        },
      ),
    );
  }

  Widget _buildEmailFormField(Size size) {

    Function validateEmail = (val) => !EmailValidator.validate(val.trim())
        ? "Please enter a valid Email"
        : null;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: TextFormField(
        decoration: emailInputDecoration,
        keyboardType: TextInputType.emailAddress,
        validator: validateEmail,
        onSaved: (value) {
          setState(() {
            mail = value.trim();
          });
        },
      ),
    );
  }

  Widget _buildConfirmPasswordFormField(Size size) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: TextFormField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock, color: AppColors.primary,),
          suffixIcon: IconButton(
            icon: Icon(
                _isObscured ? Icons.visibility_off: Icons.remove_red_eye
            ),
            onPressed: _toggleObscuredText,
            padding: EdgeInsets.fromLTRB(5, 5, 20, 5),
          ),
          fillColor: AppColors.secondary,
          filled: true,
          hintText: "Confirm Password",
          border: BorderDecoration,
          enabledBorder: BorderDecoration,
          focusedBorder: BorderDecoration,
          //prefixIcon:
        ),
        obscureText: _isObscured,
        keyboardType: TextInputType.visiblePassword,
        autocorrect: false,
        enableSuggestions: false,
        validator: (value) {
          if (value.isEmpty) {
            return "Please Enter Your Password";
          }
          if (value.length < 8) {
            return "Password must be longer than 8 characters";
          }
          if (value != pass)
            return "Passwords do not match";
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordFormField(Size size) {

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: TextFormField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock, color: AppColors.primary,),
          suffixIcon: IconButton(
            icon: Icon(
              _isObscured ? Icons.visibility_off: Icons.remove_red_eye ,
            ),
            onPressed: _toggleObscuredText,
            padding: EdgeInsets.fromLTRB(5, 5, 20, 5),
          ),
          fillColor: AppColors.secondary,
          filled: true,
          hintText: "Password",
          border: BorderDecoration,
          enabledBorder: BorderDecoration,
          focusedBorder: BorderDecoration,
          //prefixIcon:
        ),
        obscureText: _isObscured,
        keyboardType: TextInputType.visiblePassword,
        autocorrect: false,
        enableSuggestions: false,
        validator: (value) {
          if (value.isEmpty) {
            return "Please Enter Your Password";
          }
          if (value.length < 8) {
            return "Password must be longer than 8 characters";
          }
          return null;
        },
        onChanged: (value) {
          setState(() {
            pass = value;
          });
        },
      ),
    );
  }

  Widget _buildLoginText() {
    return Center(
      child: TextButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Already have an account? ", style: labelQuestion,),
            Text(
              "Log in",
              style: labelLogin,
            ),
          ],
        ),
        style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.transparent),),
        onPressed: () {
          Navigator.of(context).pushNamed('/login');
        },
      ),
    );
  }

  void _toggleObscuredText() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }
}

//STYLES

final BorderDecoration = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(29)),
  borderSide: BorderSide(
      color: AppColors.primary
  ),
);

final nameInputDecoration = InputDecoration(
  prefixIcon: Icon(Icons.person_rounded, color: AppColors.primary,),
  fillColor: AppColors.secondary,
  filled: true,
  hintText: "Name",
  border: BorderDecoration,
  enabledBorder: BorderDecoration,
  focusedBorder: BorderDecoration,
  //prefixIcon:
);

final UsernameInputDecoration = InputDecoration(
  prefixIcon: Icon(Icons.person_rounded, color: AppColors.primary,),
  fillColor: AppColors.secondary,
  filled: true,
  hintText: "Username",
  border: BorderDecoration,
  enabledBorder: BorderDecoration,
  focusedBorder: BorderDecoration,
  //prefixIcon:
);

final emailInputDecoration =  InputDecoration(
  prefixIcon: Icon(Icons.email, color: AppColors.primary,),
  fillColor: AppColors.secondary,
  filled: true,
  hintText: "Email",
  border: BorderDecoration,
  enabledBorder: BorderDecoration,
  focusedBorder: BorderDecoration,
  //prefixIcon:
);
