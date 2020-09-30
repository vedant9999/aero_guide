import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../qrcode_display.dart';

class detail_varification{

  Map<dynamic, dynamic> aadhar_value;
  Map<dynamic, dynamic> ticket_value;
  var  _ticket_text = TextEditingController();
  BuildContext context;
  DatabaseReference dataref = FirebaseDatabase.instance.reference();


  detail_varification(this.context);

  Widget build_verification()
  {
    return
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextFormField(
              controller: _ticket_text,
              decoration: InputDecoration(
                labelText: "Enter the ticket number",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(),
                ),
              ),
            ),

          ),

          Padding(
            padding: EdgeInsets.all(20.0),
            child: RaisedButton(
              child: Text("verify"),
              onPressed: () async {
                if((_ticket_text.text).isEmpty)
                {
                  _showtoast("Enter ticket number");
                }else
                {

                  FirebaseUser user = await FirebaseAuth.instance.currentUser();
                  String uid = user.uid;
                  String t_name = null;
                  String a_name = null;
                  if(dataref.child("tickets").child(_ticket_text.text) != null) {
                    dataref.child("tickets").child(_ticket_text.text)
                        .once()
                        .then((DataSnapshot datasnapshot) {
                      ticket_value = datasnapshot.value;

                      if(ticket_value == null)
                      {
                        _showtoast("Please, Enter correct ticket number");
                      }else
                      {
                        dataref.child("users").child(uid).once().then((DataSnapshot datasnapshot){

                          print(datasnapshot.value);
                          aadhar_value = datasnapshot.value;
//                                    print(values);
                          a_name = aadhar_value["name"];
                          t_name=ticket_value["name"];
                          print(a_name);
                          print(t_name);
                          if(t_name.compareTo(a_name) == 0)
                          {
                            print("//////////aaaaaaaaaaaaaaaaaaaaaaa////////////////////////");
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => qrCode("sucessfully matched")
                            ));
                          }else
                          {
                            showDialog(
                              context: context,
                              builder: (BuildContext context)
                              {
                                return
                                  AlertDialog(
                                    title: Text("ERROR"),
                                    content: Text("unsuccessful, please check your ticket id."),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text("close"),
                                        onPressed: (){
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],


                                  );
                              },
                            );
                          }


                        });
                      }

                    });


                  }
                }


              },
            ),

          ),



//          Padding(
//            padding: EdgeInsets.all(20.0),
//            child: QrImage(
//              data: ,
//            ) ,
//          )
        ],
      );



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

}