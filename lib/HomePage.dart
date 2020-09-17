import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'main.dart';


class qrCode extends StatefulWidget {


  final String text;

  qrCode(this.text);

  @override
  _qrCodeState createState() => _qrCodeState(text);
}

class _qrCodeState extends State<qrCode> {


  final String text;

  _qrCodeState(this.text);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(

        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[



          QrImage(
            data: text,
          )
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {


  @override
  _HomePageState createState() => _HomePageState();


}

class _HomePageState extends State<HomePage> {
  int _currentTab = 0;
  String _n,_adhr,_no;
  String _name = "",_aadhar = "",_number ="";
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
        _name = _n;
        _aadhar = _adhr;
        _number = _no;
      });
    });

  }

  Future _scanner() async {
    String a = await scanner.scan();
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
      body: checkTab(),
      floatingActionButton: new FloatingActionButton.extended(
          elevation: 0.0,
          icon: Icon(Icons.camera_alt),
          label: Text("Scan"),
          onPressed: _scanner,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),


          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text("Profile"),


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

  checkTab(){
    DatabaseReference dataref = FirebaseDatabase.instance.reference();

    Map<dynamic, dynamic> values;
    Map<dynamic, dynamic> value;
    final _ticket_text = TextEditingController();
    if(_currentTab ==0){

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
                            value = datasnapshot.value;

                            if(value == null)
                              {
                                _showtoast("Please, Enter correct ticket number");
                              }else
                                {
                                  dataref.child("users").child(uid).once().then((DataSnapshot datasnapshot){

                                    print(datasnapshot.value);
                                    values = datasnapshot.value;
                                    print(values);
                                    a_name = values["name"];
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

    }else if(_currentTab == 1)
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
                   child: Text("$_name"),
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
                  child: Text("$_aadhar"),
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
                  child: Text("$_number"),
                )
              ],
            ),

          ],
        );
    }
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
                    new Text("Number : " + "$_number"),

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

  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              new CircularProgressIndicator(),
              new Text("Loading"),
            ],
          ),
        );
      },
    );
    new Future.delayed(new Duration(seconds: 3), () {
      Navigator.pop(context); //pop dialog
    });
  }


}

