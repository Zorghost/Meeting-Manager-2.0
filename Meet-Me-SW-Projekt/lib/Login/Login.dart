import 'package:flutter/material.dart';
import 'package:meet_me_sw_projekt/Home/Homepage.dart';
import 'package:meet_me_sw_projekt/models/message_model.dart';
import 'package:meet_me_sw_projekt/models/user_model.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';




import '../AddEvent/addevent.dart';
import '../Contact/contactsPage.dart';
import '../ResetPassword/ResetPasswordPage.dart';
import '../RestPassword/ResetPasswordPage.dart';
import '../SignUp/SignUp.dart';
import '../models/addevent_model.dart';
import '../models/invite_model.dart';
List<User> favorites = [];
List<Message> myMessages = [];
List<Message> theMessage = [];
List<Event> myEvents = [];
List<Invite> myInvites = [];

late User currentUser ;
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

///This class extends  the UI screen and the user will be qble to Login
class _LoginState extends State<Login> {

  /// Username, Password, Email ControL and definition
  final controllerUsername = TextEditingController();
  final controllerPassword = TextEditingController();
  final controllerEmail = TextEditingController();
  bool isLoggedIn = false;
  @override
  void initState() {
    selectedEvents = {} ;
    super.initState();
  }
  /// Gui
  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: SingleChildScrollView(

        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 200, 0, 0),
          child: Container(
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),

                      ///Object
                      child: Text(

                        'Login',
                        style: TextStyle(
                          ///Property

                          /// Font Style
                            fontWeight: FontWeight.bold,
                            /// Font Color
                            color: Colors.black,

                            fontSize: 30.0),
                      ),
                    ),


                    SizedBox(height: 30.0),
                    Text(
                      'Meet-Me',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.indigoAccent,
                          fontSize: 25.0),


                    ),
                    SizedBox(
                      height: 30,
                    ),


                    TextField(
                      controller: controllerUsername,
                      enabled: !isLoggedIn,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.none,
                      autocorrect: false,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),

                          ///Show icon person
                          prefixIcon: Icon(Icons.person),
                          ///Show password as string text in User Feild   ??
                          labelText: 'Username'),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextField(
                      ///Password should check

                      controller: controllerPassword,
                      enabled: !isLoggedIn,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.none,
                      autocorrect: false,
                      decoration: InputDecoration(

                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          ///show icon lock
                          prefixIcon: Icon(Icons.lock),
                          ///show password as string text in box
                          labelText: 'Password'),

                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      height: 50,
                      child: TextButton(

                        ///Generate login as text button
                        child: const Text('Login'),

                        ///Call function doUserLogin(),
                        onPressed: isLoggedIn ? null : () => doUserLogin(),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      child: Row(

                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /// If the User has no account,
                          /// He should register himself

                          Text('Does not have account?'),
                          TextButton(

                              child: Text('Signup'),
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(

                                      ///When the user clicks the SignUp button
                                      /// it opens the SignUp page
                                        builder: (_) => SignUp()));
                                onPressed:
                                ///call function doUserLogin(),
                                !isLoggedIn ? null : () => doUserLogin();


                              }
                          )

                        ],
                      ),
                    ),

                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [


                          Text('Did you forget your Password?'),
                          TextButton(

                              child: Text('Reset Password'),
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(
                                        builder: (_) => ResetPasswordPage()));
                                onPressed:
                                /// When the user has logged in,it opens the SignIn page
                                !isLoggedIn ? null : () => doUserLogin();


                              }






                          )

                        ],
                      ),
                    ),

                  ]
              ),
            ),
          ),
        ),
      ),
    );
  }
  ///This method is called only this  called if the login was successful
  void showSuccess(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Success!"),
          content: Text(message),

        );
      },
    );
  }
  /// this method is called only when there is an error
  void showError(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error!"),
          content: Text(errorMessage),
          actions: <Widget>[
            new TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  void doUserLogin() async {

    /// Username and Password definition
    final username = controllerUsername.text.trim();
    final password = controllerPassword.text.trim();

    final user = ParseUser(username, password, null);
    var response = await user.login();



    if (response.success) {
      ///a dialog will show up indicating the success of the login
      showSuccess('Success , Loading data');
      QueryBuilder<ParseObject> queryUser =
      QueryBuilder<ParseObject>(ParseObject('Users'))
        ..whereEqualTo('name', username);

      final ParseResponse parseResponse = await queryUser.query();
      if (parseResponse.success && parseResponse.results != null) {
        final object = (parseResponse.results!.first) as ParseObject;
        currentUser = User(
            id: object.get('objectId').toString(),
            name: object.get('name').toString(),
            imageUrl: "assets/images/Profile-Pic-Icon.png",
            email: object.get('email').toString());

        getUsers();
        ///query the messagesd that have been sent to this user
        queryMessages(myMessages);
        ///query the friend´s list
        queryFriends(favorites);
        ///query the meetings that the user is participating in
        queryEvents(myEvents);

        ///query all the friends and meetings requests that this user has
        queryInvites(myInvites, currentUser.name);
        ///Login is successful?
        ///the home page is shown
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => homepage()));
        setState(() {
          debugPrint(myEvents[0].toString());
          isLoggedIn = true;
        });
      } else {
        showError(response.error!.message);
      }
    }
  }
  void navigateToUser() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => homepage()),
          (Route<dynamic> route) => false,
    );
  }

  void navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUp()),
    );
  }

  void navigateToResetPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResetPasswordPage()),
    );
  }
}

void doUserLogout() async {

}







