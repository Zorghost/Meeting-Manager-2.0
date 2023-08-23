import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meet_me_sw_projekt/models/addevent_model.dart';

///this is the attendees list of the currentUser
List<String> tempArray = [];

///this Class outputs a page where the meetinginfo will be shown
class meetinginfo extends StatefulWidget {
   ///// this method extends the info of the meeting
   final Event event ;
  meetinginfo(this.event);

  @override
  State<meetinginfo> createState() => _meetinginfoState();
}
///this class extends the state of the meetinginfo page and where all the widgets will be built
class _meetinginfoState extends State<meetinginfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('meeting Info'),
        backgroundColor: Color(0xFF4B39EF),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              buildmeetinginfo(),
            ],
          ),
        ),
      ),
    );
  }
  /// this Widget extends all Widgets of Event
  Widget buildmeetinginfo() => Column(
    children: [
      buildTitle(),
      buildStart(),
      buildEnd(),
      buildWith(),
      buildDescription(),
      buildQrCode(),

    ],
  );
  /// this Widget extends the Header of Event
  Widget buildHeader({
    required String header,
    required Widget child,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(header, style: TextStyle(fontWeight: FontWeight.bold,height: 1, fontSize: 25 ),),
          child,
        ],
      );
  /// this Widget extends the title of Event
  Widget buildTitle() => buildHeader(
    header: 'Title:',
    child: Row(
      children: [
        Expanded(
            child: Text(widget.event.title,
              textAlign: TextAlign.center,
              //overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.normal),
            )
        ),
      ],
    ),
  );

  /// this Widget extends the start Date of Event
  Widget buildStart() => buildHeader(
    header: 'Date:',
    child: Row(
      children: [
        Expanded(
            child: Text(DateFormat.yMMMEd().format(widget.event.start) + " Start " +
                DateFormat.Hm().format(widget.event.start),
              textAlign: TextAlign.center,
              //overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.normal),
            )
        ),
      ],
    ),
  );
  /// this Widget extends the End Date of Event
  Widget buildEnd() => buildHeader(
    header: 'End:',
    child: Row(
      children: [
        Expanded(
            child: Text(" End: " + DateFormat.Hm().format(widget.event.start),
              textAlign: TextAlign.center,
              //overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.normal),
            )
        ),
      ],
    ),
  );
  /// this Widget extends the attendees of Event
  Widget buildWith() => buildHeader(
    header: 'With',
    child: Row(
      children: [
        Expanded(
            child: Text(tempArray.toString(),
              textAlign: TextAlign.center,
              //overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.normal),
            )
        ),
      ],
    ),
  );
  /// this Widget extends the Description of Event
  Widget buildDescription() => buildHeader(
    header: 'Description',
    child: Row(
      children: [
        Expanded(
            child: Text(widget.event.description,
              textAlign: TextAlign.center,
              //overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.normal),
            )
        ),
      ],
    ),
  );
  /// this Widget extends the QR-Code of Event
  Widget buildQrCode() => buildHeader(
    header: 'QR Code',
    child: Row(
      children: [
        Expanded(
          child: BarcodeWidget(
            barcode : Barcode.qrCode(),
            color : Colors.black,
            data: "Events Info Title: " + widget.event.title +" Date: " + DateFormat.yMMMEd().format(widget.event.start) + " Start " +
                DateFormat.Hm().format(widget.event.start) + "End: " + DateFormat.Hm().format(widget.event.start) +" With: friends" + " Description: " + widget.event.description,
            width: 200,
            height: 150,
          ),
        ),
      ],
    ),
  );
}

