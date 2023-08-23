import 'package:flutter/material.dart';

class addfriends extends StatelessWidget {
  const addfriends({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add friends'),
      backgroundColor: Color(0xFF4B39EF),
      ),
      body: Center(
        child: Text('Add friends', style: TextStyle(fontSize: 40),),
      ),
    );
  }
}
