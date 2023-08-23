import 'package:flutter/material.dart';
import 'package:meet_me_sw_projekt/chat/chat_screen_meeting.dart';
import '../Login/Login.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';
import 'chat_screen.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';



class RecentMeetingsMessages extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
      decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30.0),
        topRight: Radius.circular(30.0),
      ),
    ),
           child: ClipRRect(
                           borderRadius: BorderRadius.only(
                           topLeft: Radius.circular(30.0),
                           topRight: Radius.circular(30.0),
                            ),
             child: Container(
          child: FutureBuilder(future: _getMeetingsMessages(),
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
                  itemCount:snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    debugPrint(snapshot.data[index].sender.id);
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreenMeeting(
                            eventid: snapshot.data[index].receiver,
                          ),
                        ),
                      ),
                      child: Container(
                        margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 20.0),
                        padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                        decoration: BoxDecoration(
                          color: snapshot.data[index].read ? Color(0xFFFFEFEE) : Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 35.0,
                                  backgroundImage: AssetImage(snapshot.data[index].sender.imageUrl),
                                  backgroundColor: Color(0xFF9C27B0),
                                ),
                                SizedBox(width: 10.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      snapshot.data[index].sender.name,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5.0),
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.45,
                                      child: Text(
                                        snapshot.data[index].text,
                                        style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  snapshot.data[index].time,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                snapshot.data[index].read
                                    ? Container(
                                  width: 40.0,
                                  height: 20.0,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF4B39EF),
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'NEW',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                                    : Text(''),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        )
    ),),);
  }
}
///this function queries all the Events of the currentUser and adds them to the Events List
Future<List<Message>> _getMeetingsMessages() async{
  late User sender = User(id: "id", name: "name", imageUrl: "assets/images/Profile-Pic-Icon.png", email: "email");
  List<String> added = [];
  List<Message> _messages = [] ;
  List<String> eventsObjectId = [] ;
  int k = 0 ;
  for( var i in myEvents)
  {
    eventsObjectId.add(i.id);
    debugPrint(eventsObjectId[k]);
    k = k +1 ;
  }

  QueryBuilder<ParseObject> queryMeetingMessages =
  QueryBuilder<ParseObject>(ParseObject('EventMessages'))
    ..whereContainedIn("receiver", eventsObjectId)..orderByDescending("createdAt");
  final ParseResponse parseResponse1 = await queryMeetingMessages.query();
  if(parseResponse1.success && parseResponse1.results != null)
  {


    for (var o in parseResponse1.result)
    {
      String s = (o).get('receiver').toString();
      if(!added.contains(s))
      {
        added.add(s);
        QueryBuilder<ParseObject> queryUserSender =
        QueryBuilder<ParseObject>(ParseObject('Event'))
          ..whereEqualTo('objectId' , s);
        final ParseResponse parseResponse4 = await queryUserSender.query();
        sender.id = s ;
        sender.email = "email@email.com";
        sender.name = ((parseResponse4.results!.first) as ParseObject).get('title').toString();
        sender.imageUrl ="assets/images/meeting_image.jpg";
        _messages.add(
            Message(
                sender: sender,
                receiver: (o).get('receiver').toString(),
                text: (o).get('Message').toString(),
                time: (o).get('updatedAt').toString().substring(11,16),
                isLiked: (o).get<bool>('isLiked')!,
                read: o.get<bool>('read')!)
        );
      }
    }
  }
  return _messages;
}
