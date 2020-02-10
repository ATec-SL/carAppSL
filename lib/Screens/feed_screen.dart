
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carappsl/Screens/profile_screenN.dart';
import 'package:carappsl/Services/auth_service.dart';
import 'package:carappsl/Services/database_service.dart';
import 'package:carappsl/models/post_model.dart';
import 'package:carappsl/models/user_model.dart';
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

  buildPost(Post post, User author){
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(
            builder: (_) => ProfileScreenN(
              currentUserId: widget.currentUserId,
              userId: post.authorId,
            ),
          ),),
          child:  Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 25.0,
                  backgroundColor: Colors.grey,
                  backgroundImage: author.profileImageUrl.isEmpty
                      ? AssetImage('assets/images/placeHolder.png')
                      : CachedNetworkImageProvider(author.profileImageUrl),
                ),
                SizedBox(width: 8.0,),
                Text(
                  author.name,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
        ),


        Container(
          height: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(post.imageUrl),
            fit: BoxFit.cover,
          )
        ),),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0 ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.favorite_border),
                    iconSize: 30.0,
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.comment),
                    iconSize: 30.0,
                    onPressed: () {},
                  )
                ],
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                '0 likes',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold
                ),
              ),),
              SizedBox(height: 4.0,),
              Row(
                children: <Widget>[
                  Container(margin: EdgeInsets.only(
                    left: 12.0,
                    right: 6.0
                  ),
                  child: Text(
                    author.name,
                    style: TextStyle(
                      fontSize: 16.0,
                        fontWeight: FontWeight.bold

                    ),
                  ),
                  ),

                  Expanded(
                    child: Text(
                      post.caption ,
                      style: TextStyle(
                        fontSize: 16.0
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )

                ],
              ),
              SizedBox(height: 12.0,)
            ],
          ),
        )
      ],
    );
  }


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
                return buildPost(post, author);
              },

            );
          },
        ),
      )

      : Center(child: CircularProgressIndicator(),) ,

    );
  }
}
