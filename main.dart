import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'HomePage.dart';

void main() => runApp(MaterialApp(

  home: MainPage(),
));

class MainPage extends StatefulWidget{


  Home createState()=> Home();
}





// ignore: must_be_immutable
class Home extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    print("/////////////////////////////////////////////////////////////////////////////////////////////////////");
    currentUser(context);


  }
  final _codeController = TextEditingController();
  final _aadharController = TextEditingController();
  Map<dynamic, dynamic> values;
  DatabaseReference dataref = FirebaseDatabase.instance.reference();
  String number;
  String aadhar;






  Future<void> Userlogin(String num , BuildContext context) async{

    FirebaseAuth _auth = FirebaseAuth.instance;
    DatabaseReference firebaseDatabase = FirebaseDatabase.instance.reference();
    _auth.verifyPhoneNumber(phoneNumber: num,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async
        {
          Navigator.of(context).pop();
          AuthResult authResult = await _auth.signInWithCredential(credential);
          FirebaseUser user = authResult.user;
          if(user != null)
          {
            dataref.child("aadhar").child(_aadharController.text).once().then((DataSnapshot datasnapshot){
              print(datasnapshot.value);
              values = datasnapshot.value;
            });
            dataref.child("users").child(user.uid).set(values);
//            Navigator.push(context, MaterialPageRoute(
//                builder: (context) => HomePage()
//
//            ));

            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => new HomePage()
            ));
            print("done");
          }
        },
        verificationFailed: (AuthException authException)
        {

          showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                title: Text("Alert"),
                content:  Text(authException.toString()),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text("Close"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );

        },
        codeSent: (String verificationId, [int forceResendingToken])
        {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                title: Text("Alert"),
                content:  Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      validator: (value)=> value.isEmpty ? 'Enter the code' : null,
                      controller: _codeController,
                      decoration: InputDecoration(
                        labelText: "Enter Code",

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(),
                        ),
                      ),


                    ),



                  ],
                ),
                actions: <Widget>[
                  // usually buttons at the bottom of the dialog
                  new FlatButton(
                    child: new Text("Confirm"),
                    onPressed: () async {
                      AuthCredential credential = PhoneAuthProvider.getCredential(verificationId: verificationId, smsCode: _codeController.text);
                      AuthResult authResult = await _auth.signInWithCredential(credential);
                      FirebaseUser user = authResult.user;
                      if(user != null)
                      {
//                        Navigator.push(context, MaterialPageRoute(
//                            builder: (context) => HomePage()
//                        ));
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => new HomePage()
                        ));
                      }
                    },
                  ),
                ],
              );
            },
          );

        },
        codeAutoRetrievalTimeout: null);
  }

  @override
  Widget build(BuildContext context) {
//    if(currentUser() != null ) {
//      Navigator.push(context, MaterialPageRoute(
//          builder: (context) => HomePage()
//      )
//      );
//    }


    return Scaffold(
      appBar: AppBar(
        title: Text("AEROGUIDE"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: TextFormField(
                  validator: (value)=> value.isEmpty ? 'Enter the Aadhar' : null,
                  controller: _aadharController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Enter Aadhar..",

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(),
                    ),
                  ),

                ),
              ),


              Padding(
                padding: EdgeInsets.all(20),
                child: RaisedButton(


                  onPressed: (){
                    dataref.child("aadhar").child(_aadharController.text).once().then((DataSnapshot datasnapshot){
                      print((datasnapshot.value).runtimeType);
                      values = datasnapshot.value;
                      print("/////////////////////////////////////////////////////////////////////////");
                      print(values);
                      Userlogin(values["number"],context);


                    });


                  },
                  child: Text("Log in"),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

}

Future<bool> currentUser(context) async {
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  if(user != null) {
//    Navigator.push(context, MaterialPageRoute(
//        builder: (context) => HomePage()
//    ));
  Navigator.of(context).pushReplacement(MaterialPageRoute(
    builder: (context) => new HomePage()
  ));
  }
}


