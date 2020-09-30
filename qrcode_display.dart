import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

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