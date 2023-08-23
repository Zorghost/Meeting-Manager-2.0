import 'package:flutter/material.dart';
import 'package:meet_me_sw_projekt/Home/Homepage.dart';
import 'package:meet_me_sw_projekt/models/message_model.dart';
import 'package:meet_me_sw_projekt/models/user_model.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

import '../Login/Login.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}
///This class extends  the UI screen and the user will be qble to Change his Password
class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final controllerEmail = TextEditingController();

  @override
  ///GUi
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Reset Password'),
          backgroundColor: Color(0xFF4B39EF),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: controllerEmail,
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.none,
                autocorrect: false,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    prefixIcon: Icon(Icons.lock),
                    labelText: 'E-mail'),

              ),
              SizedBox(
                height: 8,
              ),
              Container(
                height: 50,
                child: ElevatedButton(
                  child: const Text('Reset Password'),
                  onPressed: () => doUserResetPassword(),
                ),
              )
            ],
          ),
        ));
  }
  ///This function Responsible for changing password
  ///and saving in back4App

  void doUserResetPassword() async {
    final ParseUser user = ParseUser(null, null, controllerEmail.text.trim());
    final ParseResponse parseResponse = await user.requestPasswordReset();
    if (parseResponse.success) {
      Message.showSuccess(
          context: context,
          message: 'Password reset instructions have been sent to email!',
          onPressed: () {
            Navigator.of(context).pop();
          });
    } else {
      Message.showError(context: context, message: parseResponse.error!.message);
    }
  }
}

