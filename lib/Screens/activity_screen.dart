import 'package:flutter/material.dart';


class ActivityScreen extends StatefulWidget {
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Auto City',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'schyler',
            fontSize: 35.0,
          ),
        ),
      ),
      body: Center(
        child: Text(
            'Activity'
        ),
      ),

    );
  }
}