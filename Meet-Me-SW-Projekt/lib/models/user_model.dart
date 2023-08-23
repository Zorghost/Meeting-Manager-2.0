
import 'dart:convert';

import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

///this is the User class that is used to form user objects and defining all the important information for every person using the app
class User {
   String id = "0";
   String name = " " ;
   String imageUrl = " ";
   String email = " ";

  User({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.email,
});
}
///Query a User from database using an email
void queryUserWithEmail(String email , User user) async
{
  QueryBuilder<ParseObject> queryUserSender =
  QueryBuilder<ParseObject>(ParseObject('User'))
    ..whereEqualTo('email' , email);

  final ParseResponse parseResponse4 = await queryUserSender.query();
  user.id = ((parseResponse4.results!.first) as ParseObject).get('objectId').toString() ;
  user.email = email;
  user.name = ((parseResponse4.results!.first) as ParseObject).get('name').toString();
  user.imageUrl =(jsonDecode((parseResponse4.results!.first).get('image').toString())["url"]);
}
///Checks if a user does exist in the database
void userEmailExist(String email , bool exist ) async
{
  QueryBuilder<ParseObject> queryUserSender =
  QueryBuilder<ParseObject>(ParseObject('User'))
    ..whereEqualTo('email' , email);

  final ParseResponse parseResponse = await queryUserSender.query();

  if(parseResponse.success && parseResponse.results != null)
  {
    exist = true ;
  }
}
