import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meet_me_sw_projekt/AddEvent/addevent.dart';
import 'package:meet_me_sw_projekt/Login/Login.dart';
import 'package:meet_me_sw_projekt/Notifications/notifications_page.dart';
import 'package:meet_me_sw_projekt/Pages/addfriends.dart';
import 'package:meet_me_sw_projekt/Contact/contactsPage.dart';
import 'package:meet_me_sw_projekt/Pages/meeting.dart';
import 'package:meet_me_sw_projekt/Pages/profile.dart';
import 'package:meet_me_sw_projekt/chat/chat.dart';
import 'package:table_calendar/table_calendar.dart';

import '../Calendar/calendar.dart';
import '../models/addevent_model.dart';


///this stateful widget is the UI screen where the user will see the calendar and can switch the page of app at the bottom Navigation Bar
class homepage extends StatefulWidget {

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  @override
  void initState() {
    selectedEvents = {};
    super.initState();
  }

  int currentTab = 0;
  final List<Widget> screens = [
    meeting(),
    contactsPage(),
    Chat(),
    addfriends(),
    profile(currentUser)
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreem = meeting();
  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ??
        false;
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child : MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF4B39EF),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.notifications),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> notifications()));
            },
          ),
          title: Image.asset(
              "assets/images/logo-meet-me.png",
              height: 99.0,
              width: 50
          ),
          actions: [
            //Icon(Icons.more_vert),
            PopupMenuButton(itemBuilder: (context)=>[
              const PopupMenuItem<int>(
                value: 0,
                child: Text("Setting"),
              ),
              const PopupMenuItem<int>(
                value: 0,
                child: Text("policy page"),
              ),
              PopupMenuItem<int>(
                  value: 2,

                  child: Row(
                    children: const [
                      Icon(Icons.logout,color: Colors.black,),
                      Text("Logout")
                    ],
                  )
              ),],
            )
          ],
        ),
       body: Calendar(),
        //Add button
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.add),
          label: Text('Add Event'),
          backgroundColor: const Color(0xFF4B39EF),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  addevent()),
            );
          },
        ),
        //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          // shape: CircularNotchedRectangle(),
          //notchMargin: 5,
          child: Container(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    MaterialButton(
                      minWidth: 10,
                      onPressed: (){ Navigator.push(context,
                        MaterialPageRoute(builder: (context)=> meeting()),
                      );
                      setState(() {
                        currentScreem = meeting();

                      });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.date_range,
                            color: Color(0xFF4B39EF),
                          ),
                          Text(
                            'Meeting',
                            style: TextStyle(
                              color: Color(0xFF4B39EF),
                            ),
                          )



                        ],
                      ),

                    ),
                    MaterialButton(
                      minWidth: 10,
                      onPressed: (){ Navigator.push(context,
                        MaterialPageRoute(builder: (context)=> contactsPage()),
                      );
                      setState(() {
                        currentScreem = contactsPage();
                      });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.contacts,
                            color: Color(0xFF4B39EF),
                          ),
                          Text(
                            'Contacts',
                            style: TextStyle(
                              color: Color(0xFF4B39EF),
                            ),
                          )



                        ],
                      ),

                    ),
                    MaterialButton(
                      minWidth: 10,
                      onPressed: (){ Navigator.push(context,
                        MaterialPageRoute(builder: (context)=> Chat()),
                      );
                      setState(() {
                        currentScreem = Chat();

                      });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat,
                            color: Color(0xFF4B39EF),
                          ),
                          Text(
                            'Chats',
                            style: TextStyle(
                              color: Color(0xFF4B39EF),
                            ),
                          )



                        ],
                      ),

                    ),
                    MaterialButton(
                      minWidth: 10,
                      onPressed: (){ Navigator.push(context,
                        MaterialPageRoute(builder: (context)=> addfriends()),
                      );
                      setState(() {
                        currentScreem = addfriends();
                        currentTab = 3;
                      });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_add,
                            color: Color(0xFF4B39EF),
                          ),
                          Text(
                            'Add',
                            style: TextStyle(
                              color: Color(0xFF4B39EF),
                            ),
                          )



                        ],
                      ),

                    ),
                    MaterialButton(
                      minWidth: 10,
                      onPressed: (){ Navigator.push(context,
                        MaterialPageRoute(builder: (context)=> profile(currentUser)),
                      );
                      setState(() {
                        currentScreem = profile(currentUser);
                        currentTab = 4;
                      });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person,
                            color: Color(0xFF4B39EF) ,
                          ),
                          Text(
                            'Profile',
                            style: TextStyle(
                              color: Color(0xFF4B39EF),
                            ),
                          )
                        ],
                      ),

                    ),
                  ],
                )
              ],
            ),
          ),

        ),

      ),
      ),
    );
  }
}
