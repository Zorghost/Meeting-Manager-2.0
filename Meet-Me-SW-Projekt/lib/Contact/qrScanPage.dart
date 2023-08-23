import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:meet_me_sw_projekt/Login/Login.dart';
import 'package:meet_me_sw_projekt/models/user_model.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

///this class provides the ability to scann a QR Code using the phone Camera
class qrScanPage extends StatefulWidget {



  @override
  State<StatefulWidget> createState() => _qrScanPageState();
}

class _qrScanPageState extends State<qrScanPage> {
  String qrCode = 'Unknown';


  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text("Scan QR Code"),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Scan Result',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white54,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '$qrCode',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 72),
          OutlineButton(
            child: Text('Send Invitation', style: TextStyle(color: Colors.purple.shade300 , fontSize: 25)),
            borderSide: BorderSide(
              color: Colors.purple.shade300,
              style: BorderStyle.solid,
              width: 1.8,
            ),
            onPressed: () {scanQRCode();},
          )
        ],
      ),
    ),
  );
///this function provides the logic to transform captured Qr code into readable infomation (string)
  Future<void> scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (!mounted) return;
      setState(() {
        this.qrCode = qrCode;

      });
       if(this.qrCode == "-1") {showAlertDialog(context , qrCode);}
    } on PlatformException {
      qrCode = 'Failed to get platform version.';
    }
  }

}
showAlertDialog(BuildContext context , String qrCode ) {
  bool exist = false ;
 String theText = "Do you want to send an invitation to the user with this email : " + qrCode ;
  // set up the button
  Widget yesButton = FlatButton(
    child: Text("YES"),
    onPressed: () { 
      userEmailExist(qrCode, exist);
      if(exist = true) {
        createFriendRequest(qrCode);
        Navigator.pop(context);
        ShowSuccess(context);
      }else {ShowFailure(context);}
      },
  );
  Widget noButton = FlatButton(onPressed: () {Navigator.pop(context);}, child: Text("NO"));
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Confirmation"),
    content: Text(theText),
    actions: [
      yesButton,
      noButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

void createFriendRequest(String email ) async
{
  var invite = ParseObject("Invites")
    ..set('type' , "friend")
    ..set('title', "Friendrequest from "+ currentUser.name)
    ..set( 'subtitle', currentUser.email )
    ..set('targetEmail', email);

  await invite.save();

}
ShowSuccess(BuildContext context )
{
  return showDialog(
  context: context,
  builder: (ctx) => AlertDialog(
title: Text("Successful"),
content: Text("Invitation have been successfully sent "),
actions: <Widget>[
FlatButton(
onPressed: () {
Navigator.of(ctx).pop();
},
child: Text("Ok"),
),
],
),
);
}
ShowFailure(BuildContext context)
{
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text("Failed"),
      content: Text("this user doesn´t exist"),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(ctx).pop();
          },
          child: Text("Ok"),
        ),
      ],
    ),
  );
}