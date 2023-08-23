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

///this stateful widget is the UI screen where the user will be qble to send messages to other users
class ChatScreen extends StatefulWidget {
  final User user ;
  ChatScreen({required this.user});

  @override
  _ChatPageState createState() => _ChatPageState();


}
///This class extends the state of the ChatScreen class in order to implement further important widgets
class _ChatPageState extends State<ChatScreen> {
  ///an empty list that will be later populated with messages queried from our Back4app Database
  List<types.Message> _messages = [];
  ///this variable represents the currentUser object in order to be usable in our chat package
  final _user =  types.User(id: currentUser.id);
///this triggers some tasks but only once - when the page is visited the first time -
  @override
  void initState() {
    ///initialisation of an empty list _messages
    _messages = <types.Message>[];
    ///retrieving all the needed messages
    _loadMessages();
    ///establish a live Query that captures any change to the query results
    startLiveQuery();
    super.initState();

  }

///insert a message object to the _messages list
  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }
///this function is responsible for accessing documents in the phone in order to share them with other users
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
///this is an asynchronous function that awaits a file selection in order to form a FileMessage object with the information retrieved from this file
  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: _user,
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
  ///this is an asynchronous function that awaits an image selection in order to form a ImageMessage object with the information retrieved from this selected image
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
        author: _user,
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
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = _messages[index].copyWith(previewData: previewData);

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        _messages[index] = updatedMessage;
      });
    });
  }
  ///this is an asynchronous function that is triggered after clicking the send button in order to save the typed text message into the database and display it in the screen later on
  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );
    sendMessage(Message(sender: currentUser, receiver: widget.user.id, text: message.text, time: "", isLiked: false, read: false));
    _addMessage(textMessage);
  }
///this functions is responsible for loading all the messaging that heppened between the currentUser and the user that is clicked on
  void _loadMessages() async {
    ///the first query retrieves all the messages sent from the currentUser to the selected user
    final QueryBuilder<ParseObject> query1 = QueryBuilder<ParseObject>(ParseObject('Messages'));
    query1..whereEqualTo('sender', currentUser.id)
      ..whereEqualTo('receiver', widget.user.id);
    ///the second query retrieves all the messaegs sent from the selected user to the currentUser
    final QueryBuilder<ParseObject> query2 = QueryBuilder<ParseObject>(ParseObject('Messages'));
    query2..whereEqualTo('sender',widget.user.id)
      ..whereEqualTo('receiver',  currentUser.id);
    ///the results of the first two queries are then gathered together
    QueryBuilder<ParseObject> mainQuery = QueryBuilder.or(
      ParseObject("Messages"),
      [query1, query2],
    );

    final apiResponse = await mainQuery.query();

    if(apiResponse.success && apiResponse.results != null) {
      late User sender = User(id: "iKJwlqox6n", name: "name",email : "dfs" , imageUrl: "imageUrl");

      for (var o in apiResponse.result)
      {
        queryUser(widget.user.id , sender);
        ///results are added to the _messages list
        _messages.add(types.TextMessage( author: types.User(id : (o as ParseObject).get('sender').toString()),
            id :(o).get<String>('objectId').toString(),
            text:(o).get('message').toString(),
            createdAt: (o).get<DateTime>('createdAt')?.millisecond));
      }
    }
    ///sorting the messages in accordance of the sending time
    _messages.sort((a,b) => a.createdAt!.compareTo(b.createdAt!));
    setState(() {
      _messages ;
    });
  }
///this function update the message list directly when message has been subscribed in the database
  void startLiveQuery() async {
    final LiveQuery liveQuery = LiveQuery(debug: true);

    final QueryBuilder<ParseObject> query2 = QueryBuilder<ParseObject>(ParseObject('Messages'));
    query2..whereEqualTo('sender',widget.user.id)
      ..whereEqualTo('receiver',  currentUser.id);


    Subscription subscription = await liveQuery.client.subscribe(query2);

    subscription.on(LiveQueryEvent.create, (value) {
      print('*** CREATE ***: $value ');
      _messages.add(types.TextMessage(author: types.User(id: (value as ParseObject).get('sender').toString()),
          id: (value as ParseObject).get('objectId').toString(),
          text: (value as ParseObject).get('message').toString(),
          createdAt: (value as ParseObject).get<DateTime>('createdAt')?.millisecond));
      _messages.sort((a,b) => a.createdAt!.compareTo(b.createdAt!));
      setState(() {
        _messages;
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
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Chat(
        messages: _messages,
        onAttachmentPressed: _handleAtachmentPressed,
        onMessageTap: _handleMessageTap,
        onPreviewDataFetched: _handlePreviewDataFetched,
        onSendPressed: _handleSendPressed,
        user: _user,
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

