
import 'dart:io';

import 'package:carappsl/Services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FeedScreen extends StatefulWidget {
  static final String id = 'feed_screen';

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Zonegram',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Pacifico',
            fontSize: 35.0,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => print(''),
          )
        ],
      ),

      backgroundColor: Colors.blue,
      body: Center(
        child: FlatButton(
          onPressed: () => AuthService.logout(),
          child: Text('LOGOUT'),),
      ),

    );
  }
}
