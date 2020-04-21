import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carappsl/Screens/profile_screenN.dart';
import 'package:carappsl/models/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carappsl/models/user_model.dart';
import 'package:carappsl/resources/repository.dart';

import 'package:provider/provider.dart';

class InstaSearchScreen extends StatefulWidget {
  @override
  _InstaSearchScreenState createState() => _InstaSearchScreenState();
}

class _InstaSearchScreenState extends State<InstaSearchScreen> {
  var _repository = Repository();
  List<DocumentSnapshot> list = List<DocumentSnapshot>();
  User _user = User();
  User currentUser;
  List<User> usersList = List<User>();

  @override
  void initState() {
    super.initState();
    _repository.getCurrentUser().then((user) {
      _user.id = user.uid;
      _user.name = user.displayName;
      _user.profileImageUrl = user.photoUrl;
      _repository.fetchUserDetailsById(user.uid).then((user) {
        setState(() {
          currentUser = user;
        });
      });
      _repository.retrievePosts(user).then((updatedList) {
        setState(() {
          list = updatedList;
        });
      });
      _repository.fetchAllUsers(user).then((list) {
        setState(() {
          usersList = list;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Search'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                  context: context, delegate: DataSearch(userList: usersList));
            },
          )
        ],
      ),
      body: GridView.builder(
          //  shrinkWrap: true,
          itemCount: list.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0),
          itemBuilder: ((context, index) {
            print("LIST : ${list.length}");
            return GestureDetector(
              child: CachedNetworkImage(
                imageUrl: list[index].data['imageUrl'],
                placeholder: ((context, s) => Center(
                      child: CircularProgressIndicator(),
                    )),
                width: 125.0,
                height: 125.0,
                fit: BoxFit.cover,
              ),
              onTap: () {
                print("SNAPSHOT : ${list[index].reference.path}");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => ProfileScreenN(
                              currentUserId:
                                  Provider.of<userData>(context).currentUserId,
                              userId: list[index].data['authorId'],
                            ))));
              },
            );
          })),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  List<User> userList;

  DataSearch({this.userList});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
    // return Center(child: Container(width: 50.0, height: 50.0, color: Colors.red, child: Text(query),));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionsList = query.isEmpty
        ? userList
        : userList.where((p) => p.name.startsWith(query)).toList();
    return ListView.builder(
      itemCount: suggestionsList.length,
      itemBuilder: ((context, index) => ListTile(
            onTap: () {
              //   showResults(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => ProfileScreenN(
                            currentUserId:
                                Provider.of<userData>(context).currentUserId,
                            userId: suggestionsList[index].id,
                          ))));
            },
            leading: CircleAvatar(
              backgroundImage:
                  NetworkImage(suggestionsList[index].profileImageUrl),
            ),
            title: Text(suggestionsList[index].name),
          )),
    );
  }
}
