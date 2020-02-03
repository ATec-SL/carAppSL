import 'package:cached_network_image/cached_network_image.dart';
import 'package:carappsl/Screens/profile_screenN.dart';
import 'package:carappsl/Services/database_service.dart';
import 'package:carappsl/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();

  Future<QuerySnapshot> users;

  buildUserTile(User user){
    return ListTile(
      leading: CircleAvatar(
        radius: 20.0,
        backgroundImage: user.profileImageUrl.isEmpty ?
        AssetImage('assets/images/placeHolder.png')
            : CachedNetworkImageProvider(user.profileImageUrl),
      ),
      title: Text(
      user.name
    ),
    onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreenN(

      userId: user.id,),),
    ),
    );
  }

  clearSearch(){
    WidgetsBinding.instance
    .addPostFrameCallback((_) => _searchController.clear());
    setState(() {
      users = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextField(
          controller: _searchController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 15.0),
          border: InputBorder.none,
          hintText: 'Search',
          prefixIcon: Icon(
            Icons.search,
            size: 30.0,
             ),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.clear
            ),
            onPressed: clearSearch,

          ),
        filled: true,
        ),
          onSubmitted: (input){

            if(input.isNotEmpty){
              setState(() {
                users = DatabaseService.searchUser(input);
              });
            }
          },
        ),
      ),
      body: users == null ?
      Center(
        child: Text('Search for a user'),
      )
          :FutureBuilder(
        future: users,
        builder: (context, snapshot){
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if(snapshot.data.documents.length == 0){
          return Center(
            child: Text('No user found! Please try again'),
          );
        }
        return ListView.builder(
            itemCount: snapshot.data.documents.length,
        itemBuilder: (BuildContext context, int index){
              User user = User.fromDoc(snapshot.data.documents[index]);
              return buildUserTile(user);
        },
        );
          },),

    );
  }
}