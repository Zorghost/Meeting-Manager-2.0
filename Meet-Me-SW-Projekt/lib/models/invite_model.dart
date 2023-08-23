import 'package:meet_me_sw_projekt/Login/Login.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

/// the class invite describes the friend requests and the meeting invites in our application
class Invite {
  final String inviteId;
  final String type;
  final String title;
  final String subtitle;
  final String targetEmail;
  Invite({
    required this.inviteId,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.targetEmail,
  });
}
///this function queries all the invites that a defined user have received
void queryInvites(List<Invite> invites  , String email) async
{
  QueryBuilder<ParseObject> queryMessages =
  QueryBuilder<ParseObject>(ParseObject('Invites'))
    ..whereEqualTo('targetEmail', email) ;

  final ParseResponse parseResponse = await queryMessages.query();
  if(parseResponse.success && parseResponse.results != null) {

    for (var o in parseResponse.result)
    {
      invites.add(Invite(
          inviteId: (o as ParseObject).get("objectId").toString(),
          type: (o as ParseObject).get('type').toString(),
          title: (o as ParseObject).get('title').toString(),
          subtitle: (o as ParseObject).get('subtitle').toString(),
          targetEmail: currentUser.name));
    }
  }
}
///A function that deletes an invite from the database with the help of an ID
void deleteInvite(String inviteId) async
{
  var invite = ParseObject("Invites")..objectId = inviteId;
  await invite.delete();
}