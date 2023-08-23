//import 'dart:js';

//import 'dart:js';

import 'package:flutter/material.dart';
import 'package:meet_me_sw_projekt/models/user_model.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import '../AddEvent/addevent.dart';
import '../Home/Homepage.dart';
import '../Login/Login.dart';

///This class extends  the UI screen and  the user will be qble to Sigin
class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}



class _SignUpState extends State<SignUp> {

  ///  Username Email and Password definition
  final controllerUsername = TextEditingController();
  final controllerPassword = TextEditingController();
  final controllerEmail = TextEditingController();

  @override
  @override
  void initState() {
    selectedEvents = {} ;
    super.initState();
  }
  ///Gui
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('SignUp'),
          backgroundColor: Color(0xFF4B39EF),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'SignUp',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 30.0),
                ),
                Container(
                  height: 200,
                  child: Image.asset("assets/images/logo-meet-me.png",
                    height: 150.0,
                    width: 150.0,
                  ),
                ),
                Center(
                  child: const Text('Meet-Me',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: 16,
                ),
                Center(
                  child: const Text('User registration',
                      style: TextStyle(fontSize: 16)),
                ),
                SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: controllerUsername,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      prefixIcon: Icon(Icons.person),
                      labelText: 'Username'),

                ),
                SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: controllerEmail,
                  keyboardType: TextInputType.emailAddress,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      prefixIcon: Icon(Icons.email),
                      labelText: 'E-mail'),
                ),
                SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: controllerPassword,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      prefixIcon: Icon(Icons.lock),
                      labelText: 'Password'),
                ),
                SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: controllerPassword,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      prefixIcon: Icon(Icons.lock),
                      labelText: 'confirm password'),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  height: 50,
                  child: TextButton(
                    child: const Text('Sign Up'),
                    onPressed: () => doUserRegistration(),
                  ),
                )
              ],
            ),
          ),
        ));
  }
  ///This method is called only this  called if the SignUP was successful
  void showSuccess(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Success!"),
          content: Text(message),
          actions: <Widget>[
            new TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  /// this method is called only when there is SignUP error
  void showError(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error!"),
          content: Text(errorMessage),
          actions: <Widget>[
            new TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  ///This function controls Username Email and Password
  /// with back4app in the user area
  void doUserRegistration() async {
    final username = controllerUsername.text.trim();
    final email = controllerEmail.text.trim();
    final password = controllerPassword.text.trim();
    showDialog(
      // The user CANNOT close this dialog  by pressing outsite it
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            // The background color
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  // The loading indicator
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 15,
                  ),
                  // Some text
                  Text('Loading...')
                ],
              ),
            ),
          );
        });

    ///this is where each user's information is stored
    final user = ParseUser.createUser(username, password, email);
    var theUser = ParseObject('Users')
      ..set('name' , username.toString())
      ..set('email', email.toString());
    await theUser.save();
    var response = await user.signUp();

    if (response.success) {

      QueryBuilder<ParseObject> queryUser =
      QueryBuilder<ParseObject>(ParseObject('Users'))
        ..whereEqualTo('name', username);

      final ParseResponse parseResponse = await queryUser.query();
      if (parseResponse.success && parseResponse.results != null) {
        final object = (parseResponse.results!.first) as ParseObject;
        currentUser = User(
            id: object.get('objectId').toString(),
            name: object.get('name').toString(),
            imageUrl: "assets/images/Profile-Pic-Icon.png",
            email: object.get('email').toString());
        Navigator.of(context).pop();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => homepage()));
        showSuccess('User was successfully created! Please verify your email before Login');
      }} else {
      Navigator.of(context).pop();
      showError(response.error!.message);
    }
  }
}