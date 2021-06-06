import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_socialmedia/models/User.dart';
import 'package:project_socialmedia/services/database.dart';
import '../../utils/color.dart';
import 'package:intl/intl.dart';

class NewPost extends StatefulWidget {

  const NewPost({this.analytics,this.observer});

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {

  Size size;
  ImagePicker _picker = ImagePicker();
  File _imageFile;

  AppUser getUser()
  {
    DatabaseService(uid: user.uid).userCollection.doc(user.uid).snapshots().listen((snapshot) {
      setState(() {
        appUser.username = snapshot.get("username");
        appUser.email = snapshot.get("email");
        appUser.photoUrl = snapshot.get("photoUrl");
        appUser.displayName = snapshot.get("displayName");
        appUser.bio = snapshot.get("bio");
        userLoaded = true;
        return appUser;
      });
    });
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  User user;
  AppUser appUser = AppUser();

  bool userLoaded = false;

  String content;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setLogEvent();
    _setCurrentScreen();
  }

  @override
  Widget build(BuildContext context) {

    size = MediaQuery.of(context).size;

    user = auth.currentUser;
    if(!userLoaded)
      getUser();


    return Scaffold(
    body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBack(),
          _buildNewPost(),
        ],
      ),
    ),
    );


  }

  Future<void> _setLogEvent() async{
    await widget.analytics.logEvent(
        name: 'New_Post_Page',
        parameters: <String,dynamic> {
          'string': 'new_post'
        }
    );
  }

  Future<void> _setCurrentScreen() async{
    await widget.analytics.setCurrentScreen(
        screenName: 'New_Post_Page',
        screenClassOverride: 'New_Post_Page'

    );
  }

  _buildBack()
  {
    return AppBar(
      backgroundColor: AppColors.primary,
      title: Text("Create New Post"),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
        onPressed: () {
          content = null;
          Navigator.of(context).pop();},
      ),
      centerTitle: true,
    );
  }

  _buildNewPost()
  {
    return Column(
      children: [
        Card(
          elevation: 3,
          margin: EdgeInsets.fromLTRB(12.0,15.0,12.0,15.0),
          shadowColor: Colors.grey[50],
          child: Container(
            width: size.width,
            child:
            Column(
              children: [
                Container(
                  width: size.width-24,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10,),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(backgroundImage: AssetImage('assets/images/John.jpeg'), radius: 20,),
                              SizedBox(width: 10,),
                              Container(
                                width: size.width*0.49,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(appUser.displayName, style: TextStyle(color: Colors.grey[700] ,fontWeight: FontWeight.bold, fontSize: 18), overflow: TextOverflow.fade,),
                                    SizedBox(height: 4),
                                    Text('@${appUser.username}', style: TextStyle(color: Colors.grey[500] ,fontWeight: FontWeight.bold, fontSize: 14),),
                                  ],
                                ),
                              ),
                              Spacer(),
                              SizedBox(
                                width: 40,
                                child: FloatingActionButton(
                                    backgroundColor: AppColors.primary,
                                    child: Icon(Icons.location_on),
                                    onPressed: () {} ),
                              ),
                              SizedBox(width: 15,),
                              SizedBox(
                                width: 40,
                                child: FloatingActionButton(
                                    backgroundColor: AppColors.primary,
                                    child: Icon(Icons.add_a_photo),
                                    onPressed: () {
                                      pickImage();
                                    }),
                              ),
                              SizedBox(width: 15,),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildImage(),
                Container(
                  width: 360,
                  //height: 150,
                  child: TextField(
                    onChanged: (value)
                    {
                      setState(() {
                        content = value;
                      });
                    },
                    minLines: 3,
                    maxLines: 8,
                    autofocus: false,
                    enabled: true,
                    cursorColor: Colors.grey[500],
                    style: TextStyle(height: 1.0),
                    //maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "What's on your mind?",
                      border: OutlineInputBorder(
                        ///Color: Colors.pink,
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.green,
                          style: BorderStyle.solid,
                        ),
                      ),
                      focusedBorder:OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  width: size.width*0.85,
                  height: 40,
                  child: RaisedButton(
                      color: AppColors.primary,
                      child: Text('Post',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      //child: Icon(Icons.add),
                      onPressed: () {
                        post();
                      }),
                ),
                SizedBox(height: 10,),

              ],
            ),
          ),
        ),
      ],
    );

  }

  Future<void> post() async {
    if(_imageFile != null)
    {
      String url =  await uploadImageToFirebase(context);
      await DatabaseService(uid: user.uid).createImagePost(content == null? "" : content, DateFormat.yMd().format(DateTime.now()), url);
      content = null;
      _imageFile = null;
      Navigator.of(context).pop();
    }
    else if (content!=null) {
      await DatabaseService(uid: user.uid).createTextPost(content, DateFormat.yMd().format(DateTime.now()));
      content = null;
      Navigator.of(context).pop();
    }
  }

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

  Future<String> uploadImageToFirebase(BuildContext context) async {
    String fileName = _imageFile.path;
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('uploads$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    await uploadTask.whenComplete(() => null);
    String fileUrl = await firebaseStorageRef.getDownloadURL();
    print("***********************************************" + fileUrl);
    return fileUrl;
  }

  _buildImage() {
    if(_imageFile == null)
      return Container();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Image.file(_imageFile, height: size.width*0.8,width: size.width*0.8,),
    );
  }
}
