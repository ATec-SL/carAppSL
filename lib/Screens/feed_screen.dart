
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carappsl/Screens/chat_screen.dart';
import 'package:carappsl/Screens/profile_screenN.dart';
import 'package:carappsl/Services/auth_service.dart';
import 'package:carappsl/Services/database_service.dart';
import 'package:carappsl/models/post_model.dart';
import 'package:carappsl/models/user_model.dart';
import 'package:carappsl/widget/post_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FeedScreen extends StatefulWidget {
  static final String id = 'feed_screen';

  final String currentUserId;

  FeedScreen({this.currentUserId});

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {

  List<Post> _posts = [];

  @override
  void initState() {
    super.initState();
    setUpFeed();
  }


  setUpFeed() async {
    List<Post> posts = await DatabaseService.getFeedPosts(widget.currentUserId);

    setState(() {
      _posts = posts;
    });
  }




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
        actions: <Widget>[
          IconButton(
            icon: Icon(
                Icons.chat_bubble_outline
            ),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(
                    builder: (_) => ChatScreen()
                )),
          )
        ],
      ),

      body: _posts.length > 0
          ? RefreshIndicator(

        onRefresh: () => setUpFeed(),
        child: ListView.builder(

          itemCount: _posts.length,
          itemBuilder: (BuildContext context, int index){
            Post post = _posts[index];
            return FutureBuilder(
              future: DatabaseService.getUserWithId(post.authorId),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(!snapshot.hasData){
                  return SizedBox.shrink();
                }
                User author = snapshot.data;
                return PostView(
                  currentUserId: widget.currentUserId,
                  post: post,
                  author: author,
                );
              },

            );
          },
        ),
      )

      : Center(child: CircularProgressIndicator(),) ,

    );
  }
}
