import 'package:flutter/material.dart';
import 'package:meet_me_sw_projekt/Home/Homepage.dart';
import 'package:meet_me_sw_projekt/Login/Login.dart';

///this class presents the first page that appears when opening the application with the goal to give data some time to load
class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}
///this class extends the Splash class state in order to implement further important widgets
  class _SplashState extends State<Splash>
  {
  @override
  void initState() {
    super.initState();
    _navigatetohome();
  }
    _navigatetohome() async{
    await Future.delayed(Duration(milliseconds: 1500), () {});
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Login()));
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(color: Colors.purple),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 80.0,
                      child:
                       Image.asset("assets/images/logo-meet-me.png"),
                    ),
                   // Padding(padding: EdgeInsets.only(top: 10.0)),
                  ],
                ),
              ),
              // Expanded(
              //   flex: 1,
              // child: Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     CircularProgressIndicator.adaptive(value: 3.0,),
              //     Padding(padding: const EdgeInsets.only(top: 20.0))
              //   ],
              // ),)
            ],
          )
        ],
      ),
    );
  }
}
