import 'package:flutter/material.dart';
import 'package:meet_me_sw_projekt/Home/Homepage.dart';
import 'package:meet_me_sw_projekt/chat/Meetings_recent_Messages.dart';
import 'package:meet_me_sw_projekt/chat/chat_screen.dart';
import 'package:meet_me_sw_projekt/chat/chat_screen_meeting.dart';
import 'package:meet_me_sw_projekt/chat/recent_chats.dart';
import 'package:meet_me_sw_projekt/main.dart';
import 'package:meet_me_sw_projekt/models/message_model.dart';

import '../AddEvent/addevent.dart';
import '../Login/Login.dart';

///this the Chat screen where the UI is calculated
class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}
///this class extends the state of the chat class in order to implement further important widgets
class _ChatState extends State<Chat> {
  ///this variable specifies which widget to invoke
  int selectedIndex = 0 ;
  final List<String> categories = ['Messages', 'Meetings', 'Online', 'Contacts'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF9C27B0),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          iconSize: 30.0,
          color: Colors.white,
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> homepage()));
          },
        ),
        title: Text(
          'Chats',
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
        backgroundColor: Color(0xFF9C27B0),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          CategorySelector(),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFAB47BC),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: Column(
                children: <Widget>[
                  //FavoriteContacts(),
                  getCustomWidget(),
                  getCustomWidget2(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  ///this widget controls which widget to show depending on the selected index
  Widget getCustomWidget()
  {
    switch (selectedIndex){
      case 0 : return FavoriteContacts();
      case 1 : return MeetingGroups();
    }
    return FavoriteContacts();
  }
  Widget getCustomWidget2()
  {
    switch (selectedIndex){
      case 0 : return RecentChats();
      case 1 : return RecentMeetingsMessages();
    }
    return RecentMeetingsMessages();
  }
  ///this is the Widget in the chat screen where the index is displayed
  Widget CategorySelector() {
    return Container(
      height: 90.0,
      color: Color(0xFF9C27B0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
                debugPrint(selectedIndex.toString());
              });
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 30.0,
              ),
              child: Text(
                categories[index],
                style: TextStyle(
                  color: index == selectedIndex ? Colors.white : Colors.white60,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  ///displays the firends list of the currentUsere
  Widget FavoriteContacts() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: <Widget>[

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Favorite Contacts',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                    backgroundColor: Color(0xFFAB47BC),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.more_horiz,
                  ),
                  iconSize: 30.0,
                  color: Color(0xFFAB47BC),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Container(
            height: 120.0,
            child: ListView.builder(
              padding: EdgeInsets.only(left: 10.0),
              scrollDirection: Axis.horizontal,
              itemCount: favorites.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        user: favorites[index],
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 35.0,
                          backgroundImage:
                          NetworkImage(favorites[index].imageUrl),
                          backgroundColor: Color(0xFF9C27B0),
                        ),
                        SizedBox(height: 6.0),
                        Text(
                          favorites[index].name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
///displays the meetings chats list when the correct index is clicked on
  Widget MeetingGroups() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: <Widget>[

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Meetings Groups',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                    backgroundColor: Color(0xFFAB47BC),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.more_horiz,
                  ),
                  iconSize: 30.0,
                  color: Color(0xFFAB47BC),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Container(
            height: 120.0,
            child: ListView.builder(
              padding: EdgeInsets.only(left: 10.0),
              scrollDirection: Axis.horizontal,
              itemCount: myEvents.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreenMeeting(
                        eventid: myEvents[index].id,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 35.0,
                          backgroundImage:
                          AssetImage("assets/images/meeting_image.jpg"),
                          backgroundColor: Color(0xFF9C27B0),
                        ),
                        SizedBox(height: 6.0),
                        Text(
                          myEvents[index].title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
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