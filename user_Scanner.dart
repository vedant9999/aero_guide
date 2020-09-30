import 'package:aero_guide/qrcode_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scann;
import 'package:fluttertoast/fluttertoast.dart';

class user_scanner{

  BuildContext context;
  String _user_phone_number;


  user_scanner(this.context, this._user_phone_number);

  Future<void> scanner() async {
    String a = await scann.scan();
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
      _showtoast("Wait, we are fetching your details");
     FirebaseDatabase.instance.reference().child("users").child(user.uid).once().then((DataSnapshot datasnap){
       Map<dynamic,dynamic> value;
       value = datasnap.value;
       DatabaseReference databaseReference = FirebaseDatabase.instance.reference().child("tickets").child(a);
       databaseReference.once().then((DataSnapshot datasnapshot){

         Map<dynamic, dynamic> val;
         val = datasnapshot.value;

               if(val == null)
               {
                 _showtoast("This is not your bag");
               }else if(value["aadhar"] == val["aadhar"])
               {
                 if(val["bag"] == "no")
                 {
                   _showtoast("you dont have luggage, you have to enter the tickert number and then you will get the QR code for exit");
                 }else
                   {
                     databaseReference.child("bag").set("scaned");
                     _showDialog(user.uid);
                   }

               }else
               {
                 _showtoast("This is not your bag");
               }

       });
     });

  }
      void _showtoast(String text) {
        Fluttertoast.showToast(
            msg: text,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 16.0
        );
      }

      void _showDialog(String uid)
      {
        Map<dynamic, dynamic> values;
        FirebaseDatabase.instance.reference().child("users").child(uid).once().then((DataSnapshot datasnapshot) {
          print(datasnapshot.value);
          values = datasnapshot.value;
          String _name = values["name"];

          showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                title: Text("Details"),
                content: Container(
                    height: 100,
                    width: 200,
                    child: Column(

                      children: <Widget>[
                        new Text("Name : " + "$_name" + "\n"),
                        new Text("Number : " + "$_user_phone_number"),

                      ],
                    )
                ),



                actions: <Widget>[


                  new FlatButton(
                    child: new Text("OK. show QR code"),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => qrCode("sucessfully matched")
                      ));
                    },
                  ),

                ],
              );
            },
          );
        });

      }




}
