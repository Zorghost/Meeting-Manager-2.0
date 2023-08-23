import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:meet_me_sw_projekt/AddEvent/addevent_utils.dart';
import 'package:meet_me_sw_projekt/AddEvent/addfriendstoevents.dart';
import 'package:meet_me_sw_projekt/Calendar/calendar.dart';
import 'package:meet_me_sw_projekt/Login/Login.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import '../Home/Homepage.dart';
import '../models/addevent_model.dart';
import 'addfriendstoevents.dart';

///this is the attendees list of the event
List<String> tempArray = [];
late Map<DateTime, List<Event>> selectedEvents;
///this StatefulWidget is where the User of the event create
class addevent extends StatefulWidget {

  final Event? event;
  const addevent({Key? key, this.event}) : super(key: key);

  @override
  State<addevent> createState() => _addeventState();
}
///this class extends the state of the addevent page and where all the widgets will be built
class _addeventState extends State<addevent> {
  ///an TextEditingController that will the User insert the info about the event
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  var addController = TextEditingController();



  late DateTime fromDate;
  late DateTime toDate;

  //late DateTime fromDate;

  @override
  void initState(){
    super.initState();
    if(widget.event == null){
      fromDate = DateTime.now();
      toDate = DateTime.now().add(Duration(hours: 2));
    }
    selectedEvents = {} ;
  }

  @override
  void dispose(){
    titleController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4B39EF),
        leading: CloseButton(),
        actions: buldEditingActions(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              buildTitle(),
              SizedBox(height: 12),
              buildDateTimerPicker(),

            ],
          ),
        ),
      ),

    );
  }
  ///this widget for the save button
  List<Widget> buldEditingActions() =>[
    ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        primary: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      onPressed: saveFrom,

      icon: Icon(Icons.done),
      label: Text('Save'),
    ),
  ];
  ///this widget for insert the title of event
  Widget buildTitle() =>
      TextFormField(
        style: TextStyle(fontSize: 24),
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          hintText: "Add Title",
        ),
        onFieldSubmitted: (_) => saveFrom(),
        validator: (title)=>
        title != null && title.isEmpty ? 'Ttile cannot be empty' : null,
        controller: titleController,
      );


  Widget buildDateTimerPicker() => Column(
    children: [
      buildFrom(),
      buildTo(),
      buildWith(),
    ],
  );
  ///this widget show who is the attendees and has a button the add friends to the events page and insert the description of the event
  Widget buildWith() => buildHeader(
      header: 'With',
      child: Column(
        children: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              primary: Colors.deepPurple,
              shadowColor: Colors.transparent,
            ),
            icon: Icon(
                Icons.person_add_alt_1,
                color: Colors.white,
                size: 24.0
            ),
            label: Text('Add Friends'),
              onPressed:  (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => addfriendstoevent()),
                );
              }
          ),
          Text(tempArray.toString(),
            textAlign: TextAlign.center,
            //overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.normal),
          ),
          TextFormField(
            maxLines: 5,
            maxLength: 100,
            decoration: InputDecoration(
              hintText:'description',
            ),
            onFieldSubmitted: (_) => saveFrom(),
            validator: (description)=>
            description != null && description.isEmpty ? 'Description cannot be empty' : null,
            controller: descriptionController,
          ),
        ],
      )
  );

/// this widget is for picking the date and time start for the event
  Widget buildFrom() => buildHeader(
    header: 'Start',
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: buildDropdownField(
            text: Utils.toDate(fromDate),
            onClicked: () => pickFromDateTime(pickDate: true),
          ),
        ),
        Expanded(
          child: buildDropdownField(
            text: Utils.toTime(fromDate),
            onClicked: ()  => pickFromDateTime(pickDate: false),
          ),
        ),
      ],
    ),
  );
/// this widget ist for builder header
  Widget buildDropdownField({
    required String text,
    required  onClicked,
  }) =>
      ListTile(
        title: Text(text),
        trailing: Icon(Icons.arrow_drop_down),
        onTap: onClicked,
      );

  Widget buildHeader({
    required String header,
    required Widget child,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(header, style: TextStyle(fontWeight: FontWeight.bold ),),
          child,
        ],
      );


  /// this widget is for picking the time end for the event
  Widget buildTo() => buildHeader(
    header: 'END',
    child: Row(
      children: [
        Expanded(
          child: buildDropdownField(
            text: Utils.toTime(toDate),
            onClicked: () => pickToDateTime(pickDate: false),
          ),
        ),
      ],
    ),
  );
  Future pickFromDateTime({required bool pickDate}) async{
    final date = await pickDateTime(
        fromDate,
        pickDate: pickDate,
        firstDate: pickDate ? fromDate : DateTime.now()
    );
    if(date == null) return;
    if(date.isAfter(toDate)){
      toDate = DateTime(date.year,date.month,date.day,toDate.hour,toDate.minute);
    }
    setState(() => fromDate = date);
  }
  ///this function is for pick the date and time
  Future pickToDateTime({required bool pickDate}) async{
    final date = await pickDateTime(
      toDate,
      pickDate: pickDate,
      firstDate: pickDate ? fromDate : null,
    );
    if(date == null) return;
    setState(() => toDate = date);
  }
  Future<DateTime?>pickDateTime(
      DateTime initialDate,{
        required bool pickDate,
        DateTime? firstDate,
      }) async{
    if(pickDate){
      final date = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate ?? DateTime(2020,8),
        lastDate: DateTime(2111),
      );
      if(date ==null) return null;
      final time = Duration(hours: initialDate.hour,minutes: initialDate.minute);
      return date.add(time);
    }
    else {
      final timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );
      if(timeOfDay ==null) return null;
      final date = DateTime(initialDate.year,initialDate.month,initialDate.day);
      final time = Duration(hours: timeOfDay.hour,minutes: timeOfDay.minute);
      return date.add(time);
    }
  }
  ///this function is responsible for saving the event in Event Class in Back4app Database
  void saveFrom()async{

    final isValid = _formKey.currentState!.validate();
    if(isValid){
      final event = Event(
        id: '',
        name: currentUser.name,
        title: titleController.text,
        start: fromDate,
        end: toDate,
        description: descriptionController.text,
      );
      final eventParse = ParseObject('Event')
        ..set('name',currentUser.name)
        ..set('title', titleController.text)
        ..set('start', fromDate)
        ..set('end', toDate)
        ..set('description', descriptionController.text)
        ..set('attendees', tempArray);
      await eventParse.save();
      selectedEvents[DateTime.utc(fromDate.year,fromDate.month,fromDate.day)]?.add
        (Event(id: '', name: currentUser.name, title: titleController.text,
          start: fromDate, end: toDate, description: descriptionController.text));
      print("after add");
      print(selectedEvents[DateTime.utc(fromDate.year,fromDate.month,fromDate.day)]);
      print(DateTime.utc(fromDate.year,fromDate.month,fromDate.day));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => homepage()),
      );
      tempArray.clear();
    }
  }
  void SF()async {
    final isValid = _formKey.currentState!.validate();
    if(selectedEvents[DateTime.utc(fromDate.year,fromDate.month,fromDate.day)] != null && isValid){
      selectedEvents[DateTime.utc(fromDate.year,fromDate.month,fromDate.day)]?.add(
          Event(id: 'id', name: currentUser.name, title: titleController.text,
              start: fromDate, end: toDate, description: descriptionController.text));
    }
    else{
      selectedEvents[DateTime.utc(fromDate.year,fromDate.month,fromDate.day)] =[
        Event(id: 'id', name: currentUser.name, title: titleController.text,
            start: fromDate, end: toDate, description: descriptionController.text),
      ];
      final event = Event(
        id: '',
        name: currentUser.name,
        title: titleController.text,
        start: fromDate,
        end: toDate,
        description: descriptionController.text,
      );
      final eventParse = ParseObject('Event')
        ..set('name',currentUser.name)
        ..set('title', titleController.text)
        ..set('start', fromDate)
        ..set('end', toDate)
        ..set('description', descriptionController.text)
        ..set('attendees', tempArray);
      await eventParse.save();
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => homepage()),
    );
    tempArray.clear();


  }
}

