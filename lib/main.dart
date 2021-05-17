import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'buildApp.dart';
import 'utils/shared_prefs.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await MySharedPreferences.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
        builder: (context, snapshot)
        {
          if (snapshot.hasError) {
            print('Cannot connect to firebase: ' + snapshot.data[0].error);
            return BuildApp();
          }
          if (snapshot.connectionState == ConnectionState.done) {
            // FirebaseCrashlytics.instance.crash(); // will crash the currently running application.
            // Need to manually re-run your application on your emulator for Crashlytics to submit the crash report.
            print("Firebase Connected");
            return BuildApp();
          }
          return  BuildApp();
        }
    );
  }


}