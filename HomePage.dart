import 'package:aero_guide/Bottom%20navigation/detail_varification.dart';
import 'package:aero_guide/Bottom%20navigation/user_profile.dart';
import 'package:aero_guide/user_Scanner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_database/firebase_database.dart';


import 'package:aero_guide/Bottom navigation/google_map.dart';


import 'main.dart';




class HomePage extends StatefulWidget {


  @override
  _HomePageState createState() => _HomePageState();


}

class _HomePageState extends State<HomePage> {
  int _currentTab = 0;
  String _n,_adhr,_no;
  String _user_name = "",_user_aadhar = "",_user_phone_number ="";
  String _qrcode, _result = "";
  AnimationController _animationController;
  bool isOpen = false;
  @override
  void initState() {
    // TODO: implement initState


    getDetails();


    super.initState();
    _currentTab=0;
  }
  Future getDetails() async{
    Map<dynamic, dynamic> values;
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DatabaseReference dataref = FirebaseDatabase.instance.reference();
    dataref.child("users").child(user.uid).once().then((DataSnapshot datasnapshot){
      print(datasnapshot.value);
      values = datasnapshot.value;
      _n = values["name"];
      _adhr = values["aadhar"];
      _no = values["number"];
      print("////////////////////////////////////////here we are congrats/////////////////////////////////");
      setState(() {
        _user_name = _n;
        _user_aadhar = _adhr;
        _user_phone_number = _no;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          FlatButton(
            child: Text("sign out"),
            onPressed: _signout,

          )
        ],
      ),
      body: varification_tab(),
//      floatingActionButton: new FloatingActionButton.extended(
//          elevation: 0.0,
//          icon: Icon(Icons.camera_alt),
//          label: Text("Scan"),
//          onPressed: _scanner,
//      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black,),
            title: Text("Home"),


          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle, color: Colors.black,),
            title: Text("Profile"),


          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.location_on,
              color: Colors.black,
            ),
            title: Text("Location"),


          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.settings_overscan, color: Colors.black,),
            title:  Text(
                "Scanner",


    ),


          ),


        ],
        onTap: (index){
          setState(() {
            _currentTab = index;

          });

        },
      ),

    );
  }

  Future _signout() async {

    await FirebaseAuth.instance.signOut();

    Navigator.push(context,MaterialPageRoute(
        builder: (context) =>MainPage()
    ));
  }

  varification_tab(){



    if(_currentTab ==0){
      detail_varification varfication = new detail_varification(context);
      return varfication.build_verification();

    }else if(_currentTab == 1)
    {
     user_profile profile=new user_profile(_user_name, _user_aadhar, _user_phone_number);
     return profile.build_profile();
    }

    else if(_currentTab==2)
      {
        google_map map = new google_map();
        return map.build(context);


      }
    else if(_currentTab==3)
    {
     user_scanner scan = new user_scanner(context, _user_phone_number);
     scan.scanner();


    }


  }







}


