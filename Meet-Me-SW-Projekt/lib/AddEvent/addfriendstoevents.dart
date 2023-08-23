import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:meet_me_sw_projekt/AddEvent/addevent.dart';
import '../Contact/contactsPage.dart';
import '../Pages/profile.dart';
import '../models/user_model.dart';

///this Class outputs a page where the contacts(friends) will be shown and add to the event
class addfriendstoevent extends StatefulWidget {
//  const addfriendstoevent({Key? key}) : super(key: key);
  @override
  State<addfriendstoevent> createState() => _addfriendstoeventState();

}
///this class extends the state of the contact page and where all the widgets will be built
class _addfriendstoeventState extends State<addfriendstoevent> {
  ///an empty list that will be populated with the search results
  List<User>? selectedList;
  List<User>? usersListSearch;
  final FocusNode _textFocusNode = FocusNode();
  final TextEditingController? _textEditingController = TextEditingController();
  @override
  void dispose() {
    _textFocusNode.dispose();
    _textEditingController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contacts'),
        backgroundColor: const Color(0xFF4B39EF),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const addevent()),
              );

              },
            child: const Text("Save ✓"),
            shape: const CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
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
              controller: _textEditingController,
              decoration: const InputDecoration(
                  labelText: "Search",
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)))),
            ),
          ),
          Expanded(
            child:_textEditingController!.text.isNotEmpty &&
                usersListSearch!.length == 0
                ? Center(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.search_off,
                        size: 160,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
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
                :ListView.builder(
              itemCount: _textEditingController!.text.isNotEmpty
                  ? usersListSearch!.length
                  : usersList.length,
              itemBuilder: (ctx, index) {
                return InkWell(
                  onTap: (){
                    setState(() {
                      if(tempArray.contains(_textEditingController!.text.isNotEmpty
                          ? usersListSearch![index].name
                          : usersList[index].name)){
                        tempArray.remove(_textEditingController!.text.isNotEmpty
                            ? usersListSearch![index].name
                            : usersList[index].name);
                      }
                      else{
                        tempArray.add(_textEditingController!.text.isNotEmpty
                            ? usersListSearch![index].name
                            : usersList[index].name);
                      }
                      print('myvalue');
                      print(tempArray.toList());
                    });
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(_textEditingController!.text.isNotEmpty
                          ? usersListSearch![index].imageUrl
                          : usersList[index].imageUrl),
                    ),
                    title: Text(_textEditingController!.text.isNotEmpty
                        ? usersListSearch![index].name
                        : usersList[index].name),
                    trailing: Container(
                      height: 50,
                      width: 100,
                      decoration: BoxDecoration(
                          color:  tempArray.contains(_textEditingController!.text.isNotEmpty
                              ? usersListSearch![index].name
                              : usersList[index].name) ? Colors.red : Colors.green,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(
                        child: Text( tempArray.contains(_textEditingController!.text.isNotEmpty
                            ? usersListSearch![index].name
                            : usersList[index].name) ? 'Remove' : 'Add'),
                      ),
                    ),
                    subtitle: Text(_textEditingController!.text.isNotEmpty
                        ? usersListSearch![index].email
                        : usersList[index].email),
                  ),
                );
              },
            ),
          ),
        ],
      ),

    );
  }
}