import 'package:flutter/material.dart';
import '../utils/color.dart';
import 'package:project_socialmedia/utils/styles.dart';
import '../shared_prefs.dart';

class WalkThrough extends StatefulWidget {
  @override
  _WalkThroughState createState() => _WalkThroughState();
}

class _WalkThroughState extends State {
  int totalPage = 4;
  int curPage = 1;

  List<String> appBarTitles = ['','WELCOME','INTRO','PROFILES','CONTENT'];
  List<String> pageTitles = ['','Roommate App','Signup easily','Create your profile','Meet your next roommate'];
  List<String> imageUrls = ['','https://www.wikihow.com/images/thumb/5/59/Kick-Out-a-Dangerous-Roommate-Step-20.jpg/-crop-375-321-375px-nowatermark-Kick-Out-a-Dangerous-Roommate-Step-20.jpg','https://img.olhardigital.com.br/wp-content/uploads/2021/02/Gmail-new-logo.jpg', 'https://static.vecteezy.com/system/resources/previews/000/662/025/non_2x/social-media-profile-on-smartphone-vector.jpg', 'https://www.pngitem.com/pimgs/m/532-5320601_social-media-clipart-hd-png-download.png'];
  List<String> imageCaptions = ['','Find your next roommate','Just use your e-mail address','Update your information','Connect with people'];

  String next = "Next";

  void nextPage () {
     setState(() {
      curPage += 1;

      if(curPage == 4 ){
        next = "  Go to Welcome Screen  ";
      }
      else if(curPage == 5)
      {
        Navigator.of(context).pushNamed('/welcome');
        curPage = 4;
      }

    });

    print('You have navigated to the next page');
  }

  void prevPage() {
    setState(() {

      curPage -= 1;
      if(curPage <= 0){
        curPage = 1;
      }
      if(curPage < 4)
      {
        next = "Next";
      }

    });
    print('You have navigated to the prev page');

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF2F2F7),
        appBar: AppBar(
          backgroundColor: AppColors.secondary,
          title: Center(
            child: Text(appBarTitles[curPage],
              style: appBarTitleText,
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(pageTitles[curPage],
                style: headTextStyle,
              ),
            ),
            Center(
              child: CircleAvatar(
                backgroundImage: NetworkImage(imageUrls[curPage]),
                backgroundColor: AppColors.secondary,
                radius: 150.0,
              ),
            ),
            Center(
              child: Text(imageCaptions[curPage],
                style: captionTextStyle,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlineButton(
                  child: Text('Prev',
                    style: labelLogin,
                  ),
                  onPressed: prevPage,
                  padding: EdgeInsets.fromLTRB(1.0,2.0,1.0,2.0),

                ),
                Center(child: Text('$curPage/$totalPage',
                  style: labelLogin,
                ),
                ),
                OutlineButton(
                  child: Text(next,
                    style: labelLogin,
                  ),
                  onPressed:  nextPage,
                  padding: EdgeInsets.fromLTRB(1.0,2.0,1.0,2.0),
                )
              ],
            )
          ],
        )
    );
  }
}