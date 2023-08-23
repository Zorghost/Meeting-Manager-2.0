import 'dart:convert';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http ;
import 'package:meet_me_sw_projekt/Login/Login.dart';
import '../models/user_model.dart';
import 'addContactPage.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:meet_me_sw_projekt/Pages/profile.dart';

///this is the friends list of the currentUser
List<User> usersList = [];
///this Class outputs a page where the contacts(friends) will be shown
class contactsPage extends StatefulWidget {
  @override
  _contactsPageState createState() => _contactsPageState();
}
///this class extends the state of the contact page and where all the widgets will be built
class _contactsPageState extends State<contactsPage> {


  ///an empty list that will be populated with the search results
  List<User>? usersListSearch;
  final FocusNode _textFocusNode = FocusNode();
  TextEditingController? _textEditingController = TextEditingController();
  @override
  void dispose() {
    _textFocusNode.dispose();
    _textEditingController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.purple.shade300,
          title: Container(
            decoration: BoxDecoration(
                color: Colors.purple.shade200,
                borderRadius: BorderRadius.circular(20)),
            child: TextField(
              controller: _textEditingController,
              focusNode: _textFocusNode,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: 'Contacts',
                  contentPadding: EdgeInsets.all(8)),
              onChanged: (value) {
                setState(() {
                  usersListSearch = usersList
                      .where(
                          (element) => element.name.toLowerCase().contains(value.toLowerCase()))
                      .toList();
                  if (_textEditingController!.text.isNotEmpty &&
                      usersListSearch!.length == 0) {
                    print('userListSearch length ${usersListSearch!.length}');
                  }
                });
              },
            ),
          )),
      body: _textEditingController!.text.isNotEmpty &&
          usersListSearch!.length == 0
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.search_off,
                  size: 160,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'No results found,\nPlease try different keyword',
                  style: TextStyle(
                      fontSize: 30, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      )
          : ListView.builder(
          itemCount: _textEditingController!.text.isNotEmpty
              ? usersListSearch!.length
              : usersList.length,
          itemBuilder: (ctx, index) {
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(_textEditingController!.text.isNotEmpty
                    ? usersListSearch![index].imageUrl
                    : usersList[index].imageUrl),
              ),
              title: Text(_textEditingController!.text.isNotEmpty
                  ? usersListSearch![index].name
                  : usersList[index].name),
              subtitle: Text(_textEditingController!.text.isNotEmpty
                  ? usersListSearch![index].email
                  : usersList[index].email),
              onTap: (){
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => profile(_textEditingController!.text.isNotEmpty
                        ? usersListSearch![index]
                        : usersList[index]))
                );
              },

            );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple.shade300,
        foregroundColor: Colors.black,
        onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> addContactPage()));
        },
        child: Icon(Icons.group_add),
      ),
    );
  }
}
///this function queries all the friends of the currentUser and adds them to the usersList
getUsers() async {
  ///retrieve all the objects from the Users class with a name that equals the currentUser´s name
  QueryBuilder<ParseObject> queryFriendsVar =
  QueryBuilder<ParseObject>(ParseObject('Users'))
    ..whereEqualTo('name', currentUser.name);
  final ParseResponse parseResponse1 = await queryFriendsVar.query();
  if (parseResponse1.success && parseResponse1.results != null) {
    final friendsList = (parseResponse1.results!.first) as ParseObject;
    List<dynamic> friendsId = [];
    friendsId.addAll(friendsList.get<List>('friends')!.toList());
    for (var i in friendsId) {
      QueryBuilder<ParseObject> queryUsers =
      QueryBuilder<ParseObject>(ParseObject('Users'))
        ..whereEqualTo('objectId', i);
      final ParseResponse parseResponse2 = await queryUsers.query();
      if (parseResponse2.success && parseResponse2.results != null) {
        final object = (parseResponse2.results!.first) as ParseObject;
        usersList.add(User(
            id: object.get('objectId').toString(),
            name: object.get('name').toString(),
            imageUrl: (jsonDecode(object.get('image').toString())["url"]),
            email: object.get('email').toString()));
      }
    }
  }
}
