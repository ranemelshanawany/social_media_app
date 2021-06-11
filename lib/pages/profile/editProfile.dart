import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_socialmedia/models/User.dart';
import 'package:project_socialmedia/services/database.dart';
import '../../utils/color.dart';
import '../settings.dart';


class SettingsUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Settings UI",
      home: EditProfilePage(),
    );
  }
}

class EditProfilePage extends StatefulWidget {

  final VoidCallback  callback;

  const EditProfilePage({this.analytics,this.observer, this.callback});

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  AppUser appUser;
  User user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setLogEvent();
    _setCurrentScreen();
    FirebaseAuth auth = FirebaseAuth.instance;
    user = auth.currentUser;
  }

  Future<void> _setCurrentScreen() async{
    await widget.analytics.setCurrentScreen(
        screenName: 'Edit_Profile_Page',
        screenClassOverride: 'Edit_Profile_Page'

    );
  }

  Future<void> _setLogEvent() async{
    await widget.analytics.logEvent(
        name: 'Edit_Profile_Page',
        parameters: <String,dynamic> {
          'string': 'Edit_Profile_Page'
        }
    );
  }

  TextEditingController fullname = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController bio = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController photourl = TextEditingController();

  bool showPassword = false;
  @override
  Widget build(BuildContext context) {

    appUser = AppUser.WithUID(user.uid);

    return StreamBuilder<DocumentSnapshot<Object>>(
      stream: DatabaseService(uid: user.uid).userCollection.doc(user.uid).snapshots(),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 1,

            actions: [
              IconButton(
                icon: Icon(
                  Icons.settings,
                  color: AppColors.primary,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => SettingsPage(user: appUser)));
                },
              ),
            ],
          ),
          body: Container(
            padding: EdgeInsets.only(left: 16, top: 25, right: 16),
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: ListView(
                children: [
                  Text(
                    "Edit Profile",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 4,
                                  color: Theme.of(context).scaffoldBackgroundColor),
                              boxShadow: [
                                BoxShadow(
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    color: Colors.black.withOpacity(0.1),
                                    offset: Offset(0, 10))
                              ],
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: _imageFile == null? NetworkImage(appUser.photoUrl) : FileImage(_imageFile))),
                        ),
                        Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 4,
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                ),
                                color: AppColors.primary,
                              ),
                              child: IconButton(
                                icon: Icon(Icons.edit),
                                color: Colors.white,
                                onPressed: (){
                                  pickImage();
                                },
                              ),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  buildTextField("Full Name", appUser.displayName, false, fullname),
                  buildTextField("Username", "@${appUser.username}", false, username),
                  buildTextField("Biography", appUser.bio, false, bio),
                  buildTextField("Password", "********", true, password),

                  SizedBox(
                    height: 35,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlineButton(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("CANCEL",
                            style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 2.2,
                                color: AppColors.textColor)),
                      ),
                      RaisedButton(
                        onPressed: () async {
                          await updateProfile();
                          Navigator.of(context).pop();
                        },
                        color: AppColors.primary,
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          "SAVE",
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 2.2,
                              color: Colors.white),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  Widget buildTextField(
      String labelText, String placeholder, bool isPasswordTextField, TextEditingController controller) {
    print("rebuilt");
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
              onPressed: () {
                setState(() {
                  showPassword = !showPassword;
                });
              },
              icon: Icon(
                Icons.remove_red_eye,
                color: Colors.grey,
              ),
            )
                : null,
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.hintText,
            )),
      ),
    );
  }


  updateProfile() async
  {

    if(_imageFile != null)
      await uploadImageToFirebase(context);

    CollectionReference userCollec = FirebaseFirestore.instance.collection('users');
    AppUser newUser  = AppUser(displayName: fullname.text.isEmpty? appUser.displayName: fullname.text,
        photoUrl: photourl.text.isEmpty? appUser.photoUrl: photourl.text,
    bio: bio.text.isEmpty? appUser.bio: bio.text,
    username: username.text.isEmpty?  appUser.username : username.text);
    await userCollec.doc(user.uid).update({
      'username': newUser.username,
      'photoUrl': newUser.photoUrl,
      'displayName':  newUser.displayName,
      'bio':  newUser.bio,
    });

    if(password.text.isNotEmpty)
      await user.updatePassword(password.text);
  }

  ImagePicker _picker = ImagePicker();
  File _imageFile;

  pickImage() async {

    final ImagePicker _imagePicker = ImagePicker();
    final PickedFile _pickedImage =
    await _imagePicker.getImage(source: ImageSource.gallery);
    if (_pickedImage != null) {
      setState(() {
        _imageFile = File(_pickedImage.path);
      });
    }
  }

  uploadImageToFirebase(BuildContext context) async {
    String fileName = _imageFile.path;
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('uploads$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    await uploadTask.whenComplete(() => null);
    photourl.text = await firebaseStorageRef.getDownloadURL();
  }
}