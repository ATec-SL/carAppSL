import 'package:cached_network_image/cached_network_image.dart';
import 'package:carappsl/Services/database_service.dart';
import 'package:carappsl/models/comment_mode.dart';
import 'package:carappsl/models/user_data.dart';
import 'package:carappsl/models/user_model.dart';
import 'package:carappsl/utilties/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {

  final String postId;
  final int likeCount;

  CommentScreen({this.postId, this.likeCount});


  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {

  final TextEditingController commentController = TextEditingController();
  bool isCommeting = false;

  buildComment(Comment comment){
    return FutureBuilder(
      future: DatabaseService.getUserWithId(comment.authorId),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(!snapshot.hasData){
          return SizedBox.shrink();
        }

        User author = snapshot.data;
        return ListTile(
          leading: CircleAvatar(
            radius: 25.0,
              backgroundColor: Colors.grey,
            backgroundImage: author.profileImageUrl.isEmpty
            ? AssetImage('assets/images/placeHolder.png')
            : CachedNetworkImageProvider(author.profileImageUrl),
          ),

          title: Text(author.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(comment.content),
              SizedBox(height: 6.0,),
//             Text(
//                DateFormat.yMd().add_jm().format(comment.timestamp.toDate()),
//              ),
            ],
          ),

        );
      },
    );
  }

  buildCOmmentTF() {

    final currentUserId = Provider.of<userData>(context).currentUserId;
    return IconTheme(
      data: IconThemeData(
        color: isCommeting
            ? Theme.of(context).accentColor
            : Theme.of(context).disabledColor,
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: 10.0,),
            Expanded(
              child: TextField(
                controller: commentController,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (comment) {
                  setState(() {
                    isCommeting = comment.length>0;
                  });
                },
                decoration: InputDecoration.collapsed(hintText: 'Write a comment......'),
              ),


            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: (){
                  if(isCommeting){
                    DatabaseService.commentOnPost(
                      currentUserId: currentUserId,
                      postId: widget.postId,
                      comment: commentController.text,
                    );
                    commentController.clear();
                    setState(() {
                      isCommeting = false;
                    });

                  }
                },
              ),
            ),


          ],
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Comments',
          style: TextStyle(
            color: Colors.black
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(12.0),
              child: Text(
                '${widget.likeCount} likes',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600
                ),
              ),
          ),
          StreamBuilder(
            stream: commentRef
                .document(widget.postId)
                .collection('postComments')
                .orderBy('timestamp', descending: true)
                .snapshots(),

            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if(!snapshot.hasData) {
                return Center(
                child: CircularProgressIndicator(),
                );
              }

              return Expanded(
                child: ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index){
                      Comment comment =
                          Comment.fromDoc(snapshot.data.documents[index]);
                      return buildComment(comment);
                    }
                )
              );


          },
          ),

          Divider(height: 1.0,),
          buildCOmmentTF(),

        ],
      ),
    );
  }
}
