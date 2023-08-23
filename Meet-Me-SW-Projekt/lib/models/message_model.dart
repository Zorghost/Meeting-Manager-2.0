import 'dart:convert';

import 'package:flutter/src/widgets/framework.dart';
import 'package:meet_me_sw_projekt/Login/Login.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:meet_me_sw_projekt/models/user_model.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
///This class is used to form user objects and defining all the important information for every message in the application
class Message {
  final User sender ;
  final String receiver ;
  final String text ;
  final String time ;
  final bool isLiked;
  final bool read;
  Message({
    required this.sender,
    required this.receiver,
    required this.text,
    required this.time,
    required this.isLiked,
    required this.read,
});

  static void showSuccess({required BuildContext context, required String message, required Null Function() onPressed}) {}

  static void showError({required BuildContext context, required String message}) {}
}




///this function is used to query data from the Users class in Back4app database and adds the results to a list of users
void queryFriends(List<User> justalist) async{

  List friendsId = [];
  QueryBuilder<ParseObject> queryFriendsVar =
  QueryBuilder<ParseObject>(ParseObject('Users'))
    ..whereEqualTo('name', currentUser.name);
  final ParseResponse parseResponse1 = await queryFriendsVar.query();
  if (parseResponse1.success && parseResponse1.results != null) {
    final friendsList = (parseResponse1.results!.first) as ParseObject;

      friendsId.addAll(friendsList.get<List>('friends')!.toList());
    for (var i in friendsId)
      {
        QueryBuilder<ParseObject> queryUsers =
        QueryBuilder<ParseObject>(ParseObject('Users'))
          ..whereEqualTo('objectId', i);
        final ParseResponse parseResponse2 = await queryUsers.query();
        if (parseResponse2.success && parseResponse2.results != null) {
          final object = (parseResponse2.results!.first) as ParseObject;
                justalist.add( User(
                    id : object.get('objectId').toString(),
                    name : object.get('name').toString(),
                    imageUrl : (jsonDecode(object.get('image').toString())["url"]),
                    email: object.get('email').toString()));
              }
          }
      }
  }
///this function query a user from User class in the Back4app Database that have an objectid that should be specified in the argument
  void queryUser( String id , User justaUser) async
  {
    QueryBuilder<ParseObject> queryUserSender =
        QueryBuilder<ParseObject>(ParseObject('Users'))
        ..whereEqualTo('objectId' , id);

    final ParseResponse parseResponse4 = await queryUserSender.query();
    justaUser.id = id ;
    justaUser.email = ((parseResponse4.results!.first) as ParseObject).get('email').toString();
    justaUser.name = ((parseResponse4.results!.first) as ParseObject).get('name').toString();
    justaUser.imageUrl =(jsonDecode((parseResponse4.results!.first).get('image').toString())["url"]);


  }
///this function queries all the messages that the currentUser from the Message class in the Back4app Database have received and puts them in a list
void queryMessages(List<Message> _messages) async {

  QueryBuilder<ParseObject> queryUserMessages =
      QueryBuilder<ParseObject>(ParseObject('Messages'))
      ..whereEqualTo('receiver', currentUser.id)..orderByDescending("createdAt");
  final ParseResponse parseResponse2 = await queryUserMessages.query();
  if(parseResponse2.success && parseResponse2.results != null)
  {

    List<String> added = [];
    for (var o in parseResponse2.result)
      {
        String s = (o).get('sender').toString();
        if(!added.contains(s))
          {
            added.add(s);
        User sender = User(id: "id", name: "name", imageUrl: "assets/images/Profile-Pic-Icon.png", email: "email");
        queryUser(s , sender);
        _messages.add(
          Message(
              sender: sender,
              receiver: (o).get('receiver').toString(),
              text: (o).get('message').toString(),
              time: (o).get('updatedAt').toString().substring(11,16),
              isLiked: (o).get<bool>('isLiked')!,
              read: o.get<bool>('read')!)
        );
      }
      }
  }
}
