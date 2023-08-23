import 'package:meet_me_sw_projekt/Login/Login.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart' hide Message;
import 'package:image_picker/image_picker.dart';
import 'package:meet_me_sw_projekt/models/message_model.dart';
import 'package:meet_me_sw_projekt/models/user_model.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:uuid/uuid.dart';

import '../models/addevent_model.dart';

///this stateful widget is the UI screen where the user will be qble to send messages in a meeting group chat,
class ChatScreenMeeting extends StatefulWidget {
  final String eventid ;
  ChatScreenMeeting({required this.eventid});

  @override
  _ChatScreenMeetingState createState() => _ChatScreenMeetingState();


}
///A class that extends the state of the chat screen meeting widget
class _ChatScreenMeetingState extends State<ChatScreenMeeting> {
  ///an empty list that will be later populated later with Message objects that belongs to a defined meeting chat
  List<types.Message> _messagesMeeting = [];
  ///this event will specify which meeting chat should be opened 
  final _event =  types.User(id: currentUser.id);

  @override
  void initState() {
    _messagesMeeting = <types.Message>[];
    _loadMessages();
    startLiveQuery();
    super.initState();
  }

///this function adds a message object that belongs to a meeting conversation to the _messages list
  void _addMessage(types.Message message) {
    setState(() {
      _messagesMeeting.insert(0, message);
    });
  }
///this function is responsible for sharing the files in the meetings conversations
  void _handleAtachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: SizedBox(
            height: 144,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleImageSelection();
                  },
                  child: const Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text('Photo'),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleFileSelection();
                  },
                  child: const Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text('File'),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
///this function is responsible for creating a FileMessage object after selecting which file to share
  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: _event,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      _addMessage(message);
    }
  }
///this function is responsible for creating a FileMessage object after selecting which file to share
  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: _event,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      _addMessage(message);
    }
  }

  void _handleMessageTap(BuildContext context, types.Message message) async {
    if (message is types.FileMessage) {
      await OpenFile.open(message.uri);
    }
  }

  void _handlePreviewDataFetched(
      types.TextMessage message,
      types.PreviewData previewData,
      ) {
    final index = _messagesMeeting.indexWhere((element) => element.id == message.id);
    final updatedMessage = _messagesMeeting[index].copyWith(previewData: previewData);

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        _messagesMeeting[index] = updatedMessage;
      });
    });
  }
///this function is triggered when the send button is clicked
  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _event,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );
    sendMessage(Message(sender: currentUser, receiver: widget.eventid, text: message.text, time: "", isLiked: false, read: false));
    _addMessage(textMessage);
  }
///this function is always triggered when the chat screen is opened and it is responsible for fetching the mesage from the Message class in our Back4app database
  void _loadMessages() async {
    final QueryBuilder<ParseObject> query1 = QueryBuilder<ParseObject>(ParseObject('EventMessages'));
    query1..whereEqualTo('receiver', widget.eventid);
    final apiResponse = await query1.query();

    if(apiResponse.success && apiResponse.results != null) {
      late User sender = User(id: "iKJwlqox6n", name: "name",email : "dfs" , imageUrl: "imageUrl");

      for (var o in apiResponse.result)
      {
        queryUser(widget.eventid , sender);
        _messagesMeeting.add(types.TextMessage( author: types.User(id : (o as ParseObject).get('sender').toString()),
            id :(o).get<String>('objectId').toString(),
            text:(o).get('Message').toString(),
            createdAt: (o).get<DateTime>('createdAt')?.millisecond));
      }
    }
    _messagesMeeting.sort((a,b) => a.createdAt!.compareTo(b.createdAt!));
    setState(() {
      _messagesMeeting ;
    });
  }
///this function makes it possible that whenever a new message is added to the query results , the message list gets instantly updated
  void startLiveQuery() async {
    final LiveQuery liveQuery = LiveQuery(debug: true);

    final QueryBuilder<ParseObject> query2 = QueryBuilder<ParseObject>(ParseObject('EventMessages'));
    query2..whereEqualTo('receiver',widget.eventid);


    Subscription subscription = await liveQuery.client.subscribe(query2);

    subscription.on(LiveQueryEvent.create, (value) {
      print('*** CREATE ***: $value ');
      _messagesMeeting.add(types.TextMessage(author: types.User(id: (value as ParseObject).get('sender').toString()),
          id: (value as ParseObject).get('objectId').toString(),
          text: (value as ParseObject).get('Message').toString(),
          createdAt: (value as ParseObject).get<DateTime>('createdAt')?.millisecond));
      _messagesMeeting.sort((a,b) => a.createdAt!.compareTo(b.createdAt!));
      setState(() {
        _messagesMeeting;
      });
    });

    subscription.on(LiveQueryEvent.update, (value) {
      print('*** UPDATE ***: $value ');
    });

    subscription.on(LiveQueryEvent.delete, (value) {
      print('*** DELETE ***: $value ');
    });
  }


  @override
  ///this widget assembles all the part that the chat screen consists of
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Chat(
        messages: _messagesMeeting,
        onAttachmentPressed: _handleAtachmentPressed,
        onMessageTap: _handleMessageTap,
        onPreviewDataFetched: _handlePreviewDataFetched,
        onSendPressed: _handleSendPressed,
        user: _event,
      ),
    );
  }
}
///this function is responsible for saving the message in Message Class in Back4app Database
void sendMessage(Message k) async {

  var message = ParseObject("Messages")
    ..set('receiver' , k.receiver)
    ..set('message', k.text)
    ..set( 'sender', k.sender.id)
    ..set('isLiked', k.isLiked)
    ..set('read', k.read);

  await message.save();
}
