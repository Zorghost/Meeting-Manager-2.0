import 'dart:convert';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http ;
import 'package:intl/intl.dart';
import 'package:meet_me_sw_projekt/Login/Login.dart';
import 'package:meet_me_sw_projekt/Pages/meetinginfo.dart';
import 'package:meet_me_sw_projekt/models/addevent_model.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

///this Class outputs a page where the Events will be shown
class meeting extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Contacts'),
          backgroundColor: Color(0xFF4B39EF),
        ),
        body: Container(
          child: FutureBuilder(future: _getEvents(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.data == null)
              {
                return Container(
                  child: Center(
                    child: Text("Loading..."),
                  ),
                );
              }else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: Icon(Icons.calendar_today),
                      title: Text(snapshot.data[index].title),
                      subtitle: Text(DateFormat.yMMMEd().format(snapshot.data[index].start).toString() + " Start: " +
                          DateFormat.Hm().format(snapshot.data[index].start).toString()
                      ),
                      onTap: (){
                      Navigator.push(context,
                          new MaterialPageRoute(builder: (context) => meetinginfo(snapshot.data[index]))
                        );
                    },
                    );
                  },
                );
              }
            },
          ),
        )
    );
  }
}
///this function queries all the Events of the currentUser and adds them to the Events List
Future<List<Event>> _getEvents() async{
  List<Event> events = [];
  ///retrieve all the objects from the Event class with a name that equals the currentUser´s name
  QueryBuilder<ParseObject> queryFriendsVar =
  QueryBuilder<ParseObject>(ParseObject('Event'))
    ..whereEqualTo('name', currentUser.name);
  final ParseResponse parseResponse1 = await queryFriendsVar.query();
  if (parseResponse1.success && parseResponse1.results != null) {
    for (var i in parseResponse1.results!)
    {
      events.add(Event(id: i.get('objectId').toString(),
          name: i.get('name').toString(),
          title: i.get('title').toString(),
          start: i.get('start'),
          end: i.get('end'),
          description: i.get('description').toString()));
    }
  }
  return events;
}
