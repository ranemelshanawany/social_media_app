import 'package:flutter/material.dart';
import '../../utils/color.dart';

class PostCard extends StatelessWidget {

  final int index;
  PostCard(this.index);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 7 /4,
      child: Card(
        elevation: 1,
        child: Container(
          margin: const EdgeInsets.all(3.0),
          padding: const EdgeInsets.all(2.0),
          child: Column(
            children: <Widget>[
              _LocationAndTime(index),
              Divider(color: Colors.grey),
              _Post(index),
              Divider(color: Colors.grey),
              _PostDetails(index),
            ],
          ),
        ),
      ),
    );
  }
}

class _Post extends StatelessWidget {
  final int index;

  _Post(this.index);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Row(children: <Widget>[_PostImage(index), _PostTitleAndSummary(index)]),
    );
  }
}

class _LocationAndTime extends StatelessWidget {
  final int index;

  _LocationAndTime(this.index);

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: 400,
      height: 20,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _Location(index),
          SizedBox(width: 170),
          _PostTimeStamp(index)
        ],
      ),
    );
  }
}


class _PostTitleAndSummary extends StatelessWidget {
  final int index;

  _PostTitleAndSummary(this.index);

  @override
  Widget build(BuildContext context) {
    final TextStyle titleTheme = Theme.of(context).textTheme.title;
    final TextStyle summaryTheme = Theme.of(context).textTheme.body1;

    List<String> titles = ['Looking for a roommate!',
      'Roommate in Kadıköy',
      'Apartment for rent',
      'Apartment Free for 8 Months',
      'Looking for a Roommate ASAP!',
      'Apartment with Beautiful View'];
    List<String> summaries = ['Hi! I am looking for a roommate who is clean, animal lover and vegetarian:)',
      'Hi. I am looking for a roommate for my place in Kadıköy. Contact me if you are interested.',
      'Sadly, I am leaving my cozy apartment at the end of the month. You can contact me if you are interested in renting.',
      'I will be out of town for 8 months so if you are looking for a place to rent, contact me.',
      'I am new in İstanbul and need a place to stay as soon as possible. Please contact me!',
      'I am looking for a roommate to my apartment with a georgeous view. Contact me!!'];


    return Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 2.0),
            Text(titles[index], style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18, color: Colors.grey[900])),
            SizedBox(height: 4.0),
            Expanded(
              child: Text(summaries[index],
                  style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15, color: Colors.grey[600]),),
            ),
          ],
        ),
      ),
    );
  }
}

class _PostImage extends StatelessWidget {
  final int index;

  _PostImage(this.index);

  @override
  Widget build(BuildContext context) {
    return Expanded(flex: 2, child: Image.asset('assets/images/apartments/$index.jpeg'));
  }
}

class _PostDetails extends StatelessWidget {
  final int index;

  _PostDetails(this.index);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _UserImage(index),
          _NameAndUsername(index),
          SizedBox(width: 5,),
          SizedBox(width: 5,),
          Container(color: AppColors.primary, height: 48, width: 1.5,),
          _LikesAndComments(index),
          //Container(color: AppColors.primary, height: 48, width: 1.5,),
          SizedBox(width:10.0,),
          //_PostTimeStamp(index),
        ],
      ),
    );
  }
}

class _NameAndUsername extends StatelessWidget {
  final int index;

  _NameAndUsername(this.index);

  List<String> names = ['Claire Boucher','Mark Geller','Lana Greene','Eric Boucher','Isabella Buffay', 'Matthew Stan'];
  List<String> usernames = ['@cboucher','@markgeller','@lanagreene','@eboucher','@bellabuff', '@mattstan'];


  @override
  Widget build(BuildContext context) {
    //final TextStyle nameTheme = Theme.of(context).textTheme.subtitle;
    //final TextStyle emailTheme = Theme.of(context).textTheme.body1;

    return Expanded(
      flex: 5,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(names[index], style: TextStyle(
              fontSize: 14,
              color: Colors.grey[900]
            ),),
            SizedBox(height: 2.0),
            Text(usernames[index], style:  TextStyle(
              fontSize: 12,
              color: Colors.grey[600]
            ),),
          ],
        ),
      ),
    );
  }
}

class _LikesAndComments extends StatelessWidget {
  final int index;

  _LikesAndComments(this.index);

  List<String> usernames = ['Claire Boucher','Mark Geller','Lana Greene','Eric Boucher','Isabella Buffay', 'Matthew Stan'];
  List<String> userEmails = ['cboucher@gmail.com','markgeller@gmail.com','lanagreene@gmail.com','eboucher@gmail.com','bellabuff@gmail.com', 'mattstan@gmail.com'];


  @override
  Widget build(BuildContext context) {
    //final TextStyle nameTheme = Theme.of(context).textTheme.subtitle;
    //final TextStyle emailTheme = Theme.of(context).textTheme.body1;

    return Expanded(
      //width: 50,
      //height: 50,
      flex: 7,
      child:Row(
        children: [
          //SizedBox(width: 10,),
          SizedBox(width: 5,),
          IconButton(icon: Icon(Icons.thumb_up_alt_outlined,size: 27, color: AppColors.primary,), onPressed: () {}),
          SizedBox(width: 5,),
          Container(color: AppColors.primary, height: 48, width: 1.5,),
          SizedBox(width: 5,),
          IconButton(icon: Icon(Icons.mode_comment_outlined,size: 27, color: AppColors.primary,), onPressed: (){}),
          SizedBox(width: 5,),
          Container(color: AppColors.primary, height: 48, width: 1.5,),
          SizedBox(width: 5,),
          IconButton(icon: Icon(Icons.share,size: 27, color: AppColors.primary,), onPressed: (){}),
          SizedBox(width: 5,),

          Container(color: AppColors.primary, height: 48, width: 1.5,),

        ]
      ),

    );
  }
}

class _UserImage extends StatelessWidget {
  final int index;

  _UserImage(this.index);

  @override
  Widget build(BuildContext context) {
    return Container(
      //flex: 2,
      width: 45,
      height: 50,
      child: CircleAvatar(
        backgroundImage: AssetImage('assets/images/users/$index.jpeg'),
      ),
    );
  }
}

class _PostTimeStamp extends StatelessWidget {
  final int index;
  _PostTimeStamp(this.index);

  List<String> postTimes = ["20 April, 2021","19 April, 2021","18 April, 2021","17 April, 2021","16 April, 2021","15 April, 2021","14 April, 2021",];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //flex:2,
      height: 20,
      width: 100,
      child: Text(postTimes[index], style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.green[900],
      ),),
    );
  }
}

class _Location extends StatelessWidget {
  final int index;
  _Location(this.index);

  List<String> postTimes = ["İstanbul","Berlin","İstanbul","London","Barcelona","İstanbul","London",];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 20,
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      //flex: 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              width: 20.0,
              child: IconButton(icon: Icon(Icons.location_on,size: 20, color: AppColors.primary,), onPressed: (){}, )),
          SizedBox(width:10,),
          Container(
            padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
            child: Text(postTimes[index], style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.green[900],
            ),),
          ),

        ],

      ),
    );
  }
}