import 'package:flutter/material.dart';
import '../../utils/background.dart';
import 'package:flutter_svg/svg.dart';
import '../../utils/color.dart';
import 'package:email_validator/email_validator.dart';
import 'package:project_socialmedia/utils/styles.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isObscured = true;

  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _passValidate = false;
  bool _emailValidate = false;

  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: () {Navigator.pop(context);}, padding: EdgeInsets.all(0),),
                  Text(
                    "LOGIN",
                    style: labelSignup,
                  ),
                  SizedBox(width: 50,)
                ],
              ),
              SizedBox(height: size.height * 0.03),
              SvgPicture.asset(
                "assets/icons/hello.svg",
                height: size.height * 0.27,
              ),
              SizedBox(height: size.height * 0.03),
              _buildRoundedEmailField(
                  hintText: "Your Email",
                  onChanged: (value) {},
                  size: size
              ),
              _buildRoundedPasswordField((value){}, size),
              _buildRoundedButton(size: size, text: "LOGIN", press: (){
                setState(() {
                  _password.text.isEmpty || _password.text.length<8 ? _passValidate = true : _passValidate = false;
                  _email.text.isEmpty || !EmailValidator.validate(_email.text.trim()) ? _emailValidate = true : _emailValidate = false;
                });

                if(!_passValidate && !_emailValidate)
                {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/navigation', (Route<dynamic> route) => false);
                }

              }),
              SizedBox(height: size.height * 0.03),
              _buildSignUpText()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpText() {
    return Center(
      child: TextButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Don't have an account? ", style: labelQuestion,),
            Text(
              "Sign Up",
              style: labelLogin,
            ),
          ],
        ),
        style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.transparent),),
        onPressed: () {
          Navigator.of(context).pushNamed('/signup');
        },
      ),
    );
  }

  Widget _buildRoundedButton({Size size, String text, Function press})
  {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: FlatButton(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          color: AppColors.primary,
          onPressed: press,
          child: Text(
            text,
            style: buttonSignup,
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldContainer({Size size, Widget child})
  {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: const Color(0xFFC1EDCA),
        borderRadius: BorderRadius.circular(29),
      ),
      child: child,
    );
  }

  Widget _buildRoundedPasswordField(Function onChanged, Size size)
  {
    return _buildTextFieldContainer(
      size: size,
      child: TextField(
        controller: _password,
        obscureText: _isObscured,
        onChanged: onChanged,
        cursorColor:AppColors.primary,
        decoration: InputDecoration(
          hintText: "Password",
          icon: Icon(
            Icons.lock,
            color: AppColors.primary,
          ),
          errorText: _passValidate? "Password must be 8 characters long": null,
          suffixIcon: IconButton(
            icon: Icon(
              _isObscured ? Icons.visibility_off: Icons.remove_red_eye ,
            ),
            onPressed: _toggleObscuredText,
            padding: EdgeInsets.fromLTRB(5, 5, 20, 5),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildRoundedEmailField({Function onChanged, String hintText, Size size})
  {
    return _buildTextFieldContainer(
      size: size,
      child: TextField(
        controller: _email,
        onChanged: onChanged,
        cursorColor: AppColors.primary,
        decoration: InputDecoration(
          icon: Icon(
            Icons.person,
            color: AppColors.primary,
          ),
          errorText: _emailValidate? "Please enter valid email" : null,
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }

  void _toggleObscuredText() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }
}