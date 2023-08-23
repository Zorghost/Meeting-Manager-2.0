import 'package:flutter/material.dart';
import 'package:meet_me_sw_projekt/Login/Login.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'dart:convert';
import 'package:http/http.dart' as http ;
import 'dart:async';
///This class is used to form Event objects and define all the important information for every event in the application
class Event{
  String id = "0";
  String name = currentUser.name ;
  final String title;
  final DateTime start;
  final DateTime end;
  final String description;

  Event({
    required this.id,
    required this.name,
  required this.title,
    required this.start,
    required this.end,
    required this.description,});
}

///this function is used to query data from the Event class in Back4app database and adds the results to a list of events
void queryEvents(List<Event> events) async
{
  QueryBuilder<ParseObject> queryUserMessages =
  QueryBuilder<ParseObject>(ParseObject('Event'))
    ..whereContains('attendees', currentUser.name);
  final ParseResponse parseResponse = await queryUserMessages.query();
  if(parseResponse.success && parseResponse.results != null)
  {
    for (var o in parseResponse.result)
    {
      events.add(Event(
          id: (o as ParseObject).get('objectId').toString(),
          name: (o as ParseObject).get('name').toString(),
          title: (o as ParseObject).get('title').toString(),
          start: (o as ParseObject).get('start'),
          end: (o as ParseObject).get('end'),
          description: (o as ParseObject).get('description').toString()));
    }
  }
}

