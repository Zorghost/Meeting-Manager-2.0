import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meet_me_sw_projekt/Pages/meeting.dart';
import 'package:meet_me_sw_projekt/Pages/meetinginfo.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:table_calendar/table_calendar.dart';
import '../Login/Login.dart';
import '../models/addevent_model.dart';
///This class creates the calendars in HomePage using the calendar dart library
class Calendar extends StatefulWidget {


  @override
  State<Calendar> createState() => _CalenderState();

}

class _CalenderState extends State<Calendar> {

  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();


  Map<DateTime, List<Event>> myEvents = {};
  List<Event> Events = [];
  List str = [];
  @override
  void initState() {
    getEvents();
    super.initState();
  }

  List<Event> _getEventsfromDay(DateTime day) {
    for (int i = 0;i <= Events.length - 1; i++){
      print('start events');
      //Liste von start Event
      print(str[i]);
      //List von Events info
      print(Events[i]);
      myEvents[str[i]]= Events;
    }
    return   myEvents[day] ?? [];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TableCalendar(
            focusedDay: selectedDay,
            firstDay: DateTime(1990),
            lastDay: DateTime(2050),
            calendarFormat: format,
            onFormatChanged: (CalendarFormat _format) {
              setState(() {
                format = _format;
              });
            },
            startingDayOfWeek: StartingDayOfWeek.sunday,
            daysOfWeekVisible: true,

            //Day Changed
            onDaySelected: (DateTime selectDay, DateTime focusDay) {
              setState(() {
                selectedDay = selectDay;
                focusedDay = focusDay;
              });
            },
            selectedDayPredicate: (DateTime date) {
              return isSameDay(selectedDay, date);
            },
            eventLoader: _getEventsfromDay,
            //To style the Calendar
            calendarStyle: CalendarStyle(
              isTodayHighlighted: true,
              selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              selectedTextStyle: TextStyle(color: Colors.white),
              todayDecoration: BoxDecoration(
                color: Colors.purpleAccent,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              defaultDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              weekendDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: true,
              titleCentered: true,
              formatButtonShowsNext: false,
              formatButtonDecoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(5.0),
              ),
              formatButtonTextStyle: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          ..._getEventsfromDay(selectedDay).map(
                (Event event) =>
                ListTile(
                  title: Text(
                    event.title,
                  ),
                  subtitle: Text(
                      DateFormat.yMMMEd().format(event.start).toString() +
                          " Start: " +
                          DateFormat.Hm().format(event.start).toString()
                  ),
                  trailing: Icon(Icons.chevron_right),
                  dense: true,
                  onTap: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => meetinginfo(event))
                    );
                  },
                ),
          )
        ],
      ),
    );
  }
  ///this function queries all the Events of the currentUser and adds them to the Events List
  void getEvents() async {
    DateTime start;
    QueryBuilder<ParseObject> queryFriendsVar =
    QueryBuilder<ParseObject>(ParseObject('Event'))
      ..whereEqualTo('name', currentUser.name);
    final ParseResponse parseResponse1 = await queryFriendsVar.query();
    if (parseResponse1.success && parseResponse1.results != null) {
      for (var i in parseResponse1.results!) {
        Events.add(Event(id: i.get('objectId').toString(),
            name: i.get('name').toString(),
            title: i.get('title').toString(),
            start: i.get('start'),
            end: i.get('end'),
            description: i.get('description').toString()));
        start = i.get('start');
        str.add(DateTime.utc(start.year,start.month,start.day));
        //myEvents[DateTime.utc(start.year, start.month, start.day)]= Events;
      }
     for (int i = 0;i <= Events.length - 1; i++){
        print('start events');
        //Liste von start Event
        print(str[i]);
        //List von Events info
        print(Events[i]);
        myEvents[str[i]]= Events;
      }

      setState(() {
        Events;
        myEvents;
      });
    }
  }
}


