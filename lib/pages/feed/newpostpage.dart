import 'package:flutter/material.dart';
import 'package:project_socialmedia/utils/color.dart';

class NewPost extends StatefulWidget {
  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {

  Size size;

  @override
  Widget build(BuildContext context) {

    size = MediaQuery.of(context).size;
    return Scaffold(
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBack(),
        _buildNewPost(),
      ],
    ),
    );


  }

  _buildBack()
  {
    return AppBar(
      backgroundColor: AppColors.primary,
      title: Text("Create New Post"),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10,),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(backgroundImage: AssetImage('assets/images/John.jpeg'), radius: 20,),
                              SizedBox(width: 10,),
                              Column(
                                children: [
                                  Text('John F.', style: TextStyle(color: Colors.grey[700] ,fontWeight: FontWeight.bold, fontSize: 18),),
                                  SizedBox(height: 4),
                                  Text('@JohnF', style: TextStyle(color: Colors.grey[500] ,fontWeight: FontWeight.bold, fontSize: 14),),
                                ],
                              ),
                              Spacer(),
                              SizedBox(
                                width: 30,
                                child: FloatingActionButton(
                                    backgroundColor: AppColors.primary,
                                    child: Icon(Icons.add_a_photo),
                                    onPressed: () {} ),
                              ),
                              SizedBox(width: 20,),
                              RaisedButton(
                                  color: AppColors.primary,
                                  child: Text('Post',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  //child: Icon(Icons.add),
                                  onPressed: () => Navigator.of(context).pop()),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 360,
                  //height: 150,
                  child: TextField(
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
                SizedBox(height: 20,),
              ],
            ),
          ),
        ),

      ],
    );

  }


}
