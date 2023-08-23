import 'package:flutter/material.dart';
import 'package:meet_me_sw_projekt/main.dart';
import 'package:meet_me_sw_projekt/models/invite_model.dart';

import '../Login/Login.dart';
///this notifications page contains all the invitations that the currentUser have received but still pending
class notifications extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _notificationsState();
}
///	This class extends the state of the notifications class page and where all the widgets will be built
class _notificationsState extends State<notifications> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.all(10),
          child: myInvites.isEmpty
              ? Center(
            child: Text("No data found"),
          )
              : (myInvites.isEmpty)
              ? Container(
            color: Colors.transparent,
            child: Center(
              child: CircularProgressIndicator(
                valueColor:
                AlwaysStoppedAnimation<Color>(Colors.pink),
              ),
            ),
          )
              : ListView.builder(
            itemCount: myInvites.length,
            itemBuilder: (context, index) {
              return _createListRow(myInvites[index], index);
            },
          ),
        ),
      ),
    );
  }
  ///this is the UI in which items in the list view consist of
  _createListRow(Invite item, int index) {
    return Card(
      elevation: 3,
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: [
              Text(item.title),
              Text(item.subtitle),
            ],
          ),
          FlatButton(
            child: Text("Accept"),
            onPressed: () {
              setState(() {
                myInvites.removeAt(index);
              });
            },
          ),
          FlatButton(
            child: Text("Decline"),
            onPressed: () {
              setState(() {
                deleteInvite(myInvites[index].inviteId);
                myInvites.removeAt(index);
              });
            },
          )
        ],
      ),
    );
  }
}