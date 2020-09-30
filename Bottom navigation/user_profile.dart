import 'package:flutter/material.dart';
class user_profile{

  String _user_name;
  String _user_aadhar;
  String _user_phone_number;


  user_profile(this._user_name, this._user_aadhar, this._user_phone_number);

  Widget build_profile()
  {
    return
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Text("Name: "),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Text("$_user_name"),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Text("Aadhar: "),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Text("$_user_aadhar"),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Text("number: "),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Text("$_user_phone_number"),
              )
            ],
          ),

        ],
      );
  }

}