// @dart=2.9
import 'package:flutter/material.dart';
import 'package:meet_me_sw_projekt/Login/Login.dart';
import 'package:meet_me_sw_projekt/models/addevent_model.dart';
import 'package:meet_me_sw_projekt/models/user_model.dart';
import 'package:meet_me_sw_projekt/splash.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:meet_me_sw_projekt/models/message_model.dart';
import 'Contact/contactsPage.dart';
import 'Home/Homepage.dart';
import 'package:meet_me_sw_projekt/chat/chat_screen.dart';

import 'models/invite_model.dart';
/// this list contains the messages of a conversation between the currentUser and a user
List<Message> theMessage = [];



void main() async {

  final keyApplicationId = 'IWT4vYbiIwU00i88xmMQUyqg1xgkE8JIorjueTj7';
  final keyClientKey = 'AAv03QdKhPiZkGhNXI6M7W2RRROl3NsbreyDWcGs';
  final keyParseServerUrl = 'https://parseapi.back4app.com';
/// initialisation of the connection with the Back4app Database
  await Parse().initialize(
      keyApplicationId, keyParseServerUrl, clientKey: keyClientKey,connectivityProvider: CustomParseConnectivityProvider(),
      autoSendSessionId: true, liveQueryUrl :'https://meetme-b4app.b4a.io',debug: true);


  /* Mit diesem Code können Sie die Verbindung zur Datenbank testen , Ihr müsst nur den String ändern

  var firstObject = ParseObject('TestClass')
    ..set(
        'message', 'STRING HIER EINFÜGEN');
  await firstObject.save();

  print('done');

*/



  runApp( MyApp());
}


///This class  provides general information about the app layout as whole
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MeetMe",
      theme: ThemeData(
        primaryColor: Color(0xFF4B39EF),
        accentColor: Color(0xFF4B39EF),
      ),
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}
///Input that should be provided in the Database Connection initializer in order to work with liveQueries
class CustomParseConnectivityProvider extends ParseConnectivityProvider{

  @override
  Future<ParseConnectivityResult> checkConnectivity() async => ParseConnectivityResult.wifi;

  @override
  Stream<ParseConnectivityResult> get connectivityStream => Stream<ParseConnectivityResult>.empty();

}