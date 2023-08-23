import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:meet_me_sw_projekt/Contact/qrScanPage.dart';
import 'package:meet_me_sw_projekt/Login/Login.dart';
import 'package:barcode_widget/barcode_widget.dart';

import '../models/user_model.dart';

///this class defines the addcontact page where the user can Add other users to his friends list with the help of a QR Code or just by sending an invitation using his email

class addContactPage extends StatefulWidget {

  @override
  State<addContactPage> createState() => _addContactPageState();

}
///this class extends the state of the addContactPage Class in order to develop the important widgets in the page.
class _addContactPageState extends State<addContactPage> {
  final controllerEmail = TextEditingController();
  @override
  ///triggers important task when the addContactPage first appears
  void initState() {
    super.initState();

    SchedulerBinding.instance!.addPostFrameCallback((_) {
      showAlertDialog(context);
    });
  }
  ///this alert Dialog contains a hint for the user in order to know how to easily scan QR codes
  showAlertDialog(BuildContext context) {

    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {Navigator.pop(context); },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Hint :", style: TextStyle(color: Colors.purple.shade300)),
      content: Text("Scan a friend's QR Code to add them to contact list" ),
      actions: [
        okButton,
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
  @override
  ///this Widget consists of elements that represent mainly the UI of the addContactPage
  Widget build(BuildContext context) {
  bool userexist = false ;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Send an Invite'),
      ),
      body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: BarcodeWidget(
                  barcode : Barcode.qrCode(),
                  color : Colors.black,
                  data: currentUser.name,
                  width: 300,
                  height: 300,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                    width: 250.0,
                    height: 50.0,
                    margin: EdgeInsets.symmetric(vertical: 3.0),
                    child: SizedBox.expand(
                        child: OutlineButton(
                          child: Text('With QR Code', style: TextStyle(color: Colors.purple.shade300 , fontSize: 25)),
                          borderSide: BorderSide(
                            color: Colors.purple.shade300,
                            style: BorderStyle.solid,
                            width: 1.8,
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> qrScanPage()));
                          },
                        )
                    )

                ),
              ),
              Container(
                  width: 250.0,
                  height: 50.0,
                  margin: EdgeInsets.symmetric(vertical: 3.0),
                  child: SizedBox.expand(
                      child: OutlineButton(
                        child: Text('With Email', style: TextStyle(color: Colors.purple.shade300 , fontSize: 25)),
                        borderSide: BorderSide(
                          color: Colors.purple.shade300,
                          style: BorderStyle.solid,
                          width: 1.8,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                            title: Text("Email Here"),
                            content: TextField(
                              controller:   controllerEmail,
                              decoration: InputDecoration(hintText: "Enter the email here"),
                            ) ,
                              actions: [
                                TextButton(child: Text("SUBMIT"),
                                           onPressed: () {
                                             userEmailExist(controllerEmail.text.trim(), userexist);
                                             if(userexist = true) {
                                               createFriendRequest(controllerEmail.text.trim());
                                               Navigator.pop(context);
                                               ShowSuccess(context);
                                             }else {ShowFailure(context);}
                                           },),
                                TextButton(child: Text("CANCEL"),
                                  onPressed: () {Navigator.pop(context);}
                                  ,),
                              ],
                            ),
                          );
                        },
                      )
                  )

              ),
            ],
          )
      ),
    );
  }
}