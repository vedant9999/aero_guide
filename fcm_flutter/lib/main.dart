import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

void main() => runApp(MaterialApp(
  home: MyApp(),
));

class MyApp extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<MyApp> with SingleTickerProviderStateMixin {

  String token_fcm;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  DatabaseReference data = FirebaseDatabase.instance.reference().child("token");
  DatabaseReference dataref = FirebaseDatabase.instance.reference().child("text");
  @override
  void initState() {
    super.initState();
    fcm_function();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: Text("FCM DEMO"),

    ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text("press me"),
              onPressed: () async {
                await http.post(
                  'https://fcm.googleapis.com/fcm/send',
                  headers: <String, String>{
                    'Content-Type': 'application/json',
                    'Authorization': 'AAAA1kyOvSQ:APA91bFsI7sydndoMWUvEkdhq43xMLW0IOSARSq53FudrQQT1tU2tI1teobStXg0xTKjX6WEniOkr745FdA16-lb8rpt3bQBE2CGdjdhA7-rXGm8ScVOtGmKR5NyMMzxlks1XU39AcPy',
                  },
                  body: jsonEncode(
                    <String, dynamic>{
                      'notification': <String, dynamic>{
                        'body': 'this is a body',
                        'title': 'this is a title'
                      },
                      'priority': 'high',
                      'data': <String, dynamic>{
                        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                        'id': '1',
                        'status': 'done'
                      },
                      'to': token_fcm,
                    },
                  ),
                );
              },

            )
          ],
        ),
      ),
    );

  }

  void fcm_function() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );

    _firebaseMessaging.getToken().then((token) {
      print(token);
      token_fcm = token;

      data.child(token).child("token").set(token);
    });
  }





}





